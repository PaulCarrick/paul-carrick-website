class Admin::BlogsController < ApplicationController
  include Pagy::Backend

  before_action :set_blog, only: %i[show edit update destroy]

  def index
    if params[:sort].present?
      session[:blog_posts_sort] = params[:sort]
    elsif session[:blog_posts_sort].present?
      params[:sort] = session[:blog_posts_sort]
    else
      params[:sort] = nil
    end

    if params[:direction].present?
      session[:blog_posts_sort_direction] = params[:direction]
    elsif session[:blog_posts_sort_direction].present?
      params[:direction] = session[:blog_posts_sort_direction]
    else
      params[:direction] = nil
    end

    # Set default sort column and direction
    sort_column = params[:sort].presence || "title"
    sort_direction = params[:direction].presence || "asc"

    # Safeguard against invalid columns and directions
    sort_column = MenuItem.column_names.include?(sort_column) ? sort_column : "title"
    sort_direction = %w[asc desc].include?(sort_direction) ? sort_direction : "asc"

    @pagy, @blogs = pagy(BlogPost.order("#{sort_column} #{sort_direction}"), limit: 30)
  end

  def show
  end

  def new
    @blog = BlogPost.new
  end

  def create
    @blog = BlogPost.new(blog_params)

    if @blog.save
      redirect_to admin_blogs_path, notice: "BlogPost created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @blog.update(blog_params)
      redirect_to admin_blogs_path, notice: "BlogPost updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @blog.destroy
    redirect_to admin_blogs_path, notice: "BlogPost deleted successfully."
  end

  private

  def set_blog
    @blog = BlogPost.find(params[:id])
  end

  def blog_params
    params.require(:blog_post).permit(:author, :title, :content, :posted)
  end
end
