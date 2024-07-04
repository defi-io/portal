SitemapGenerator::Sitemap.default_host = "https://defi.io"

SitemapGenerator::Sitemap.create do
  
  LatestPrice.find_each do |lp|
    add "#{lp.symbol.downcase}-to-usd", :lastmod => lp.updated_at
  end

  pages = Spina::Page.live
  pages.each do |page|
    translations = page.translations
      translations.each do |p|
        add p.materialized_path, :lastmod => page.published_at
      end
  end

end