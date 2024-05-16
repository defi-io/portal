class AddOriginalUrlAndPublishedAtToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :spina_pages, :original_url, :string, unique: true
    add_column :spina_pages, :published_at, :datetime, precision: nil
  end
end
