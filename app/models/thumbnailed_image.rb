class ThumbnailedImage < AbstractFileBlock

  acts_as_content_block :versioned => { :version_foreign_key => :file_block_id },
    :belongs_to_attachment => true, :taggable => true

  include ImageProcessing

  after_save :create_thumbnails

  THUMBNAIL_SIZES = {
    'medium' => {:width => 200}
  }

  def set_attachment_file_path
    if @attachment_file_path && @attachment_file_path != attachment.file_path
      attachment.file_path = @attachment_file_path
    end
  end

  def set_attachment_section
    if @attachment_section_id && @attachment_section_id != attachment.section_id
      attachment.section_id = @attachment_section_id
    end
  end

  def self.display_name
    "Thumbnailed Image"
  end

#  def self.version_foreign_key
#    'file_block_id'
#  end

#  def self.instance_variable_name_for_view
#    '@content_block'
#  end

  private

  def full_image_path
    return self.attachment && self.attachment.full_file_location
  end

  def ext
    return self.attachment && self.attachment.file_extension
  end

  def create_thumbnails
    # if this image is only for a specific size - then only resize it to that size
    get_thumbnail_sizes.keys.each do |key|
      create_thumbnail(key)
    end
  end

end
