class PhotoGalleryPortlet < Portlet

  # Mark this as 'true' to allow the portlet's template to be editable via the CMS admin UI.
  enable_template_editor true
     
  def render
    per_page = @portlet.per_page.to_i > 0 ? @portlet.per_page.to_i : 10
    page = params[:ppage].to_i > 0 ? params[:ppage].to_i : 1
    @section = Section.find_by_id(@portlet.section_id.to_i) || Section.root
    @photos = ThumbnailedImage.by_section(@section).paginate(:per_page => per_page, :page => page, :order => 'file_blocks.published_date ASC, file_blocks.created_at DESC')
  end
    
end
