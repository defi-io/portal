class AddAuthorToSpinaPages < ActiveRecord::Migration[7.1]
  def change
    add_column :spina_pages, :author, :string
  end
end
