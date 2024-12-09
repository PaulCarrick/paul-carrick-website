# /app/controllers/admin/image_files

class Admin::ImageFilesController < Admin::AbstractAdminController
  def initialize
    super

    @page_limit = 4
    @default_column = 'name'
    @has_query = true
    @has_sort = true
    @sort_column = nil
    @sort_direction = nil
    @results = nil
    @model_class = ImageFile
  end

  private

  def get_params
    parameters = {}

    if params[:q].present? # Searching via ransack
      parameters[:q] = params.require(:q).permit(:nane_cont,
                                                 :caption_cont,
                                                 :description_cont,
                                                 :mime_type_cont,
                                                 :group_cont,
                                                 :slide_order_cont)
    else # File
      if params[:image_file].present?
        parameters = params.require(:image_file).permit(:nane,
                                                        :caption,
                                                        :description,
                                                        :mime_type,
                                                        :group,
                                                        :slide_order,
                                                        :checksum)
      else # Get
        parameters = params.permit(:sort,
                                   :direction,
                                   :clear_sort,
                                   :clear_search)
      end
    end

    parameters
  end
end
