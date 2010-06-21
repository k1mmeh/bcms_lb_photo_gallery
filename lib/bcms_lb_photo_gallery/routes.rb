module Cms::Routes
  def routes_for_bcms_lb_photo_gallery
    namespace(:cms) do |cms|
      cms.content_blocks :thumbnailed_images
    end  
  end
end
