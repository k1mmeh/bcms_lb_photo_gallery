class CreateThumbnailedImages < ActiveRecord::Migration
  def self.up
    add_column(:file_blocks, :description, :text)
    add_column(:file_block_versions, :description, :text)
    add_column(:file_blocks, :published_date, :date)
    add_column(:file_block_versions, :published_date, :date)
    ContentType.create!(:name => "ThumbnailedImage", :group_name => "LB Photo Gallery")
  end

  def self.down
    remove_column(:file_blocks, :description)
    remove_column(:file_block_versions, :description)
    remove_column(:file_blocks, :published_date)
    remove_column(:file_block_versions, :published_date)
    ContentType.delete_all(['name = ?', 'ThumbnailedImage'])
    CategoryType.all(:conditions => ['name = ?', 'Thumbnailed Image']).each(&:destroy)
  end
end
