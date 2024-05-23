class AddShortUrlToSpinaPageTranslations < ActiveRecord::Migration[7.0]
  def change
    add_column :spina_page_translations, :short_url, :string
  end
end
