# /app/assets/controllers/admin/abstract_admin_controller.rb

# Abstract base class for Admin Items

class Admin::AbstractAdminController < ApplicationController
  include Pagy::Backend
  include Persistence

  def initialize
    if self.class == Admin::AbstractAdminController
      raise NotImplementedError, "#{self.class} is an abstract class and cannot be instantiated."
    end

    super

    @page_limit = nil
    @default_column = nil
    @has_query = false
    @has_sort = false
    @sort_column = nil
    @sort_direction = nil
    @results = nil
    @model_class = controller_name.classify.constantize
    @fields = @model_class.column_names
                          .map(&:to_sym)
                          .reject { |column| [ :id, :created_at, :updated_at ].include?(column) }
  end

  def index
    begin
      set_items
    rescue => e
      handle_error(:index, e)
    end
  end

  def new
    begin
      set_item(true)
    rescue => e
      handle_error(:index, e)
    end
  end

  def create
    begin
      result = @model_class.create!(get_params)

      if result.persisted?
        redirect_to action: :index, notice: "#{controller_name.classify.constantize} created successfully."
      else
        raise("Could not create #{controller_name.classify.constantize}.")
      end
    rescue => e
      handle_error(:new, e)
    end
  end

  def update
    begin
      set_item

      if get_record&.update(get_params)
        redirect_to action: :index, notice: "#{controller_name.classify.constantize} updated successfully."
      else
        raise("Could not update #{controller_name.classify.constantize}, ID: #{params[:id]}.")
      end
    rescue => e
      handle_error(:edit, e)
    end
  end

  def edit
    begin
      set_item
    rescue => e
      handle_error(:index, e)
    end
  end

  def show
    begin
      set_item
    rescue => e
      handle_error(:index, e)
    end
  end

  def destroy
    begin
      set_item

      result = get_record&.destroy

      if result.destroyed?
        redirect_to action: :index, notice: "#{controller_name.classify.constantize} deleted successfully."
      else
        raise("Could not delete #{controller_name.classify.constantize}, ID: #{params[:id]}.")
      end
    rescue => e
      handle_error(:index, e)
    end
  end

  def get_item
    get_record
  end

  def get_items
    get_records
  end

  def get_unfiltered_items
    @model_class.all
  end

  private

  def get_singular_record_name
    "@_#{controller_name.singularize}"
  end

  def get_plural_record_name
    "@_#{controller_name}"
  end

  def get_record
    instance_variable_get(get_singular_record_name)
  end

  def get_records
    instance_variable_get(get_plural_record_name)
  end

  def handle_error(action, e)
    debugger if Rails.env == 'development' && ENV["PAUSE_ERRORS"]

    @error_message = get_record&.errors&.full_messages&.join(", ")
    @error_message = e&.message unless @error_message.present?
    @error_message = "An error occurred." unless @error_message.present?
    @error_message = "There was an error with the #{@model_class}: #{@error_message}"
    flash[:error] = @error_message

    redirect_to action: action, notice: "#{@error_message}) please correct any errors."
  end

  def set_item(create = false, create_params = {})
    if create
      @result = @model_class.new(create_params)
    else
      @result = @model_class.find(params[:id])
    end

    instance_variable_set(get_singular_record_name, @result)
  end

  def set_items
    @results = []
    @sort_column, @sort_direction = set_sorting(@default_column, params.deep_dup)
    @q = set_search(params.deep_dup)

    if @has_query && @q.present?
      if @has_sort && @sort_column.present? && @sort_direction.present?
        @results = @q.result(distinct: true).order("#{ActiveRecord::Base.connection.quote_column_name(@sort_column)} #{@sort_direction}")
        if @page_limit.present?
          @pagy, @results = pagy(@results, limit: @page_limit)
        else
          @pagy, @results = pagy(@results)
        end
      else
        @results = @q.result(distinct: true)

        if @page_limit.present?
          @pagy, @results = pagy(@results, limit: @page_limit)
        else
          @pagy, @results = pagy(@results)
        end
      end
    else
      if @sort_column.present? && @sort_direction.present?
        @pagy, @results = pagy(@model_class.all.order("#{ActiveRecord::Base.connection.quote_column_name(@sort_column)} #{@sort_direction}"))
      else
        @pagy, @results = pagy(@model_class.all)
      end
    end

    @results = instance_variable_set(get_plural_record_name, @results)
  end

  def get_params
    params.require(controller_name.singularize.to_sym).permit(@fields)
  end
end
