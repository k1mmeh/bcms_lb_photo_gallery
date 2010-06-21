##
# All methods from this helper will be available in the render.html.erb for PhotoGalleryPortlet
module PhotoGalleryPortletHelper

  def split_list_into_pairs(list)
    rows = []
    list.each_with_index do |item, i|
      if i % 2 == 0
        rows << [item]
      else
        rows.last << item
      end
    end

    return rows
  end
  
end
