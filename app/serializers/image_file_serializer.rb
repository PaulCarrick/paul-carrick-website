class ImageFileSerializer
  def initialize(image_file)
    @image_file = image_file
  end

  def as_json(_options = {})
    {
      id: @image_file.id,
      name: @image_file.name,
      mime_type: @image_file.mime_type,
      caption: @image_file.caption,
      description: @image_file.description,
      image_url: @image_file.image.attached? ? Rails.application.routes.url_helpers.rails_blob_url(@image_file.image, only_path: true) : nil
    }
  end
end
