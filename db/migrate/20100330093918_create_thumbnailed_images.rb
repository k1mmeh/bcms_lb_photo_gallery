class CreateThumbnailedImages < ActiveRecord::Migration
  def self.up
    add_column(:file_blocks, :description, :text)
    ContentType.create!(:name => "ThumbnailedImage", :group_name => "LB Photo Gallery")
  end

  def self.down
    remove_column(:file_blocks, :description)
    ContentType.delete_all(['name = ?', 'ThumbnailedImage'])
    CategoryType.all(:conditions => ['name = ?', 'Thumbnailed Image']).each(&:destroy)
  end
end
