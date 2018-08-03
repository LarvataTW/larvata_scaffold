class Attachment < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :attachable, polymorphic: true

  attr_accessor :attachment
  has_attached_file :attachment,
    styles: ->(attachment) { attachment.instance.pdf? ? {} : { small: "100x100#", thumb: "166x166#", middle: "300x300#" } },
    default_url: "http://placehold.it/300x300"

  validates_with AttachmentSizeValidator, attributes: :attachment, less_than: 100.megabytes
  do_not_validate_attachment_file_type :attachment

  #one convenient method to pass jq_upload the necessary information
  def to_jq_upload
    {
      "id" => id,
      "name" => attachment.original_filename,
      "size" => attachment.size,
      "url" => attachment.url(:original),
      "thumbnail_url" => attachment.url(:thumb),
      "delete_url" => attachment_path(id: id),
      "delete_type" => "DELETE"
    }
  end

  def pdf?
    attachment_content_type == "application/pdf"
  end
end

