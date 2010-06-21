class CreateThumbnailedImages < ActiveRecord::Migration
  def self.up

    ContentType.create!(:name => "ThumbnailedImage", :group_name => "Kaeo Kerikeri Church")
  end

  def self.down
    ContentType.delete_all(['name = ?', 'ThumbnailedImage'])
    CategoryType.all(:conditions => ['name = ?', 'Thumbnailed Image']).each(&:destroy)
  end
end
