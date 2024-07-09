class AddImageUrlToSpinaPages < ActiveRecord::Migration[7.1]
  def change
    add_column :spina_pages, :image_url, :string
  end
end
