class AddKeywordsToSpinaPages < ActiveRecord::Migration[7.1]
  def change
    add_column :spina_pages, :keywords, :string
  end
end
