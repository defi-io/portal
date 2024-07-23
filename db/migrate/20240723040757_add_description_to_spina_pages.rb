class AddDescriptionToSpinaPages < ActiveRecord::Migration[7.1]
  def change
    add_column :spina_pages, :description, :text
  end
end
