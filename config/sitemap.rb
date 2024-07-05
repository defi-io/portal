SitemapGenerator::Sitemap.default_host = "https://defi.io"

SitemapGenerator::Sitemap.create do
  
  LatestPrice.find_each do |lp|
    coin = lp.symbol.downcase
    # add coin, :lastmod => lp.updated_at 
    currencies = [:usd, :cny, :eur, :gbp, :aud, :cad, :jpy, :sgd, :hkd]
    currencies.each do |c|
      add "#{coin}-to-#{c}", :lastmod => lp.updated_at 
    end
  end

  pages = Spina::Page.live
  pages.each do |page|
    translations = page.translations
      translations.each do |p|
        add p.materialized_path, :lastmod => page.published_at
      end
  end

end