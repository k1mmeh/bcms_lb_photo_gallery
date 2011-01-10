module ImageProcessing

  module ClassMethods

    def get_size_for_image(size)
      sizes = self::THUMBNAIL_SIZES
      if sizes[size][0] && sizes[size][1]
        width = sizes[size][0]
        height = sizes[size][1]
        return width.to_s + 'x' + height.to_s
      end

      return nil
    end

  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  ##############################################################################
  # Path helper methods
  #
  def full_image_path_for_size(size)
    return [full_image_path, get_size_for_image(size)].compact.join('.')
  end
  #
  # end path helper methods
  ##############################################################################


  private

  # ensure that each class that mixes in ImageProcessing implements this method
  def create_thumbnails
    raise Exception, "Method not implemented. 'create_thumbnails' must be declared for the class to mixin ImageProcessing"
  end

  # each class that mixes in ImageProcessing needs to specify which thumbnail sizes
  # it expects to process.
  def get_thumbnail_sizes
    # validate here (unless)
    return self.class::THUMBNAIL_SIZES
  end

  # create a new version of width 'new_width' and height 'new_height'.  If the aspect ratio
  # is not correct, place the image on a white canvas
  def create_thumbnail(size = 'medium')
    new_width = get_thumbnail_sizes[size][:width]
    new_height = get_thumbnail_sizes[size][:height]

    # Load the image
    begin
      image_file = Magick::Image.read(full_image_path).first
    rescue Magick::ImageMagickError
      return false
    end

    if new_width.nil?
      ar = aspect_ratio(image_file)
      new_width = (new_height.to_f * ar.to_f).to_i
    elsif new_height.nil?
      ar = aspect_ratio(image_file)
      new_height = (new_width.to_f / ar.to_f).to_i
    end

    # if image is a jpeg and already this size, don't resize.  Just copy instead
    if image_file.format == 'JPEG' && image_dimensions_match?(image_file, new_width, new_height)
      FileUtils.copy(full_image_path, full_image_path_for_size(size))
      return true
    end

    # Only resize if original is bigger
    if (image_file.columns > new_width) && (image_file.rows > new_height)
      # now resize the image to within the given bounds
      image_file.change_geometry!("#{new_width}x#{new_height}") do |cols, rows, img|
        img.resize!(cols, rows)
      end
    end

    # check to see it the fit is exact
    unless image_dimensions_match?(image_file, new_width, new_height)
      bg = Magick::Image.new(new_width, new_height)

      image_file = bg.composite(image_file, Magick::CenterGravity, Magick::OverCompositeOp)
    end

    # finally write the new file
    image_file.format = 'JPEG'
    image_file.write(full_image_path_for_size(size))

    return true
  end

  def image_dimensions_match?(image_file, width, height)
    return image_file.rows == height && image_file.columns == width
  end

  def aspect_ratio(image_file)
    return image_file.columns.to_f / image_file.rows.to_f
  end

  def path_without_extension(path)
    return path.to_s.mb_chars.sub(/\.#{Regexp.escape(ext.to_s)}$/i, '')
  end

  # See also application_helper.rb
  def get_size_for_image(size_key)
    sizes = get_thumbnail_sizes

    return nil unless sizes[size_key]
    return [sizes[size_key][:width].to_s, sizes[size_key][:height].to_s].join('x')
  end
  
end
