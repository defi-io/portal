class News::Page
  
  def batch
    p Time.now
    p Spina::Page.count

    News::Ct.new.list
    News::Ct.new.list_to_detail

    News::Cd.new.list
    News::Cd.new.list_to_detail

    # News::Dc.new.list
    # News::Dc.new.list_to_detail
    
    News::Page.new.pedding_short
    p Spina::Page.count
    p Time.now
  end
  
  def short_url(url)
    Shortener::ShortenedUrl.generate(url).unique_key
  end
  
  def pedding_short
    domain = 'https://defi.io'
    Spina::Page.where.not(original_url: nil).order(published_at: :desc).each do |page|
      translations = page.translations
        translations.each do |t|
          key = short_url(domain + t.materialized_path)
          t.short_url = key
          t.save
        end
    end
  end
  
end