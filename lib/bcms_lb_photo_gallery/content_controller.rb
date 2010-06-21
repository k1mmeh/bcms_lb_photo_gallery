Cms::ContentController
class Cms::ContentController < Cms::ApplicationController

  def try_to_stream_file
    split = @paths.last.to_s.split('.')
    ext = split.size > 1 ? split.last.to_s.downcase : nil

    #Only try to stream cache file if it has an extension
    unless ext.blank?

      #Check access to file
      @attachment = Attachment.find_live_by_file_path(@path)
      if @attachment
        raise Cms::Errors::AccessDenied unless current_user.able_to_view?(@attachment)

        #Construct a path to where this file would be if it were cached
        if thumb = ThumbnailedImage.find(:first, :conditions => ["attachment_id = ?", @attachment.id])
          @file = thumb.full_image_path_for_size(params[:size])
        else
          @file = @attachment.full_file_location
        end

        #Stream the file if it exists
        if @path != "/" && File.exists?(@file)
          send_file(@file,
            :filename => @attachment.file_name,
            :type => @attachment.file_type,
            :disposition => "inline"
          )
        end
      end
    end
  end
  
end