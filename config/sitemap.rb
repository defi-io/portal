SitemapGenerator::Sitemap.default_host = "https://defi.io"

SitemapGenerator::Sitemap.create do

  pages = Spina::Page.live
  pages.each do |page|
    translations = page.translations
      translations.each do |p|
        next if p.locale != "zh-CN"
        add p.materialized_path, :lastmod => p.updated_at
      end
  end

end