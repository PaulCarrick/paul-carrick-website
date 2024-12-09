# /app/assets/controllers/admin/abstract_admin_controller.rb

# Abstract base class for Admin Items

class Admin::AbstractAdminController < ApplicationController
  include Pagy::Backend
  include Persistence

  before_action :set_item, only: %i[ show edit update destroy ]
  before_action :set_items, only: %i[ index ]

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
  end

  def index
  end

  def new
    @model_class.new
  end

  def create
    result = @model_class.create(get_params)

    if result.persisted?
      redirect_to action: :index, notice: "#{controller_name.classify.constantize} created successfully."
    else
      redirect_to action: :new, notice: "Could not create #{controller_name.classify.constantize}."
    end
  end

  def update
    if @model_class.update(get_params)
      redirect_to action: :index, notice: "#{controller_name.classify.constantize} updated successfully."
    else
      redirect_to action: :edit, notice: "Could not update #{controller_name.classify.constantize}, ID: #{get_params[:id]}."
    end
  end

  def edit
  end

  def show
  end

  def destroy
    result = self.destroy

    if result.destroyed?
      redirect_to action: :index, notice: "#{controller_name.classify.constantize} deleted successfully."
    else
      redirect_to action: :index, notice: "Could not delete #{controller_name.classify.constantize}, ID: #{get_params[:id]}."
    end
  end

  private

  def set_item
    instance_variable_name = "@#{controller_name.singularize}"

    instance_variable_set(instance_variable_name, @model_name.find(get_params[:id]))
  end

  def set_items
    parameters = get_params
    instance_variable_name = "@#{controller_name}"
    @results = []
    @sort_column, @sort_direction = set_sorting(@default_column, parameters)
    @q = set_search(parameters)

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

    @results = instance_variable_set(instance_variable_name, @results)
  end

  def get_params
    params
  end
end
