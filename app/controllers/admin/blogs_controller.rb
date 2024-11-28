class Admin::BlogsController < ApplicationController
  include Pagy::Backend

  before_action :set_blog, only: %i[show edit update destroy]

  def index
    sort_column = params[:sort] || 'title' # Default sorting column
    sort_direction = params[:direction] || 'asc' # Default sorting direction
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
