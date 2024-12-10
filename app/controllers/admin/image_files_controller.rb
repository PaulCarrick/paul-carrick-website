# /app/controllers/admin/image_files

class Admin::ImageFilesController < Admin::AbstractAdminController
  def initialize
    super

    @page_limit = 4
    @default_column = 'name'
    @has_query = true
    @has_sort = true
    @model_class = ImageFile
    @fields = ImageFile.column_names
                       .map(&:to_sym)
                       .reject { |column| [ :id, :name, :created_at, :updated_at ].include?(column) }
  end
end
