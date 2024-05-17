class News::Ct
  include News::Crawle
  include Tool::Deepl
  
  def list
    get_list(home_url('CT'))
    
    # get_detail
  end
  
  def get_list(url)
    doc = get_doc(url)
    
    ancestry = get_ancestry('Cointelegraph')
    
    doc.css('article.post-card__article').each do |article|
      title = article.css('span.post-card__title').first.text
      link = article.css('header a').first['href']
      url = home_url('ct') + link
      original_page = Spina::Page.find_by_original_url(url)
      next if original_page
      
      page = Spina::Page.new
      page.original_url = url
      page.ancestry = ancestry
      save_page_detail(page, title)
    end
  end
  
  def list_to_detail
    Spina::Page.where.not(original_url: nil).where(published_at: nil).order(created_at: :desc).limit(10).each do |page|
      p "="*99, page.id, page.title
      get_detail(page)
    end
  end
  
  def get_detail(page)  
    # url = "https://cointelegraph.com/news/bitcoin-etf-volumes-7-week-high-btc-price-67k"
    # url = "https://cointelegraph.com/news/bitcoin-traders-eye-price-indicators-for-jump-to-70000"
    # url = "https://cointelegraph.com/news/pink-drainer-hacker-retirement-85m-theft"
    # url = "https://cointelegraph.com/news/big-bitcoin-miners-growing-threat-bitcoin"
    # url = "https://cointelegraph.com/news/onboarding-crypto-adoption-challenges"
    # url = "https://cointelegraph.com/news/deep-forest-celebrates-grammy-anniversary-with-exclusive-itheum-music-data-nft-collection"
    # url = "https://cointelegraph.com/news/over-80-binance-token-listings-loss-red"
    # url = "https://cointelegraph.com/news/navigating-crypto-surges-securing-profit-during-market-rallies"
    # url = "https://cointelegraph.com/news/bitcoin-golden-cross-last-sparked-170-btc-price-gains"
    
    doc = get_doc(page.original_url)
    
    title = doc.css('h1.post__title').first.text
    
    published_at = get_published_at(doc)
    
    img_html_tag = get_img(doc)

    doc = doc.css('div.post__content-wrapper')
    
    doc = clean_doc(doc)
    
    content = img_html_tag + doc.first.to_html
    
    page.published_at = published_at
    
    save_page_detail(page, title, content)
  end
  
  def clean_doc(doc)
    shares_list = doc.search('div.shares-list__list')
    shares_list.remove.each(&:remove) if shares_list
    
    related = doc.search('p strong em')
    related.remove.each(&:remove) if related   
    
    disclaimer = doc.search('p.post-content__disclaimer')
    disclaimer.remove.each(&:remove) if disclaimer
    
    tags_list = doc.search('ul.tags-list__list')
    tags_list.remove.each(&:remove) if tags_list    
    
    reactions = doc.search('div.reactions_3eiuR')
    reactions.remove.each(&:remove) if reactions   
    
    clean_link(doc)
    doc
  end
  
  def clean_link(doc)
    doc.css('a').each do |link|
      link.replace(link.content)
    end
    doc
  end
  
  def get_img(doc)
    image_url = nil
 
    img_urls = doc.css('img').map { |img| img['src'] }

    img_urls.each do |img_url|
      puts img_url
      image_url = img_url if img_url.include?("images.cointelegraph.com")
    end
    
    img_html_tag = "<img src='#{image_url}'>"
  end
  
  def get_published_at(doc)
    time = doc.css('div.post-meta__publish-date time').first.text.downcase
    i = time.match(/\d+/)[0].to_i
    published_at = nil
    if time.include?('hour')
      published_at = i.hours.ago
    elsif time.include?('minute')
      published_at = i.minutes.ago
    elsif time.include?('day')
      published_at = i.days.ago
    end
    published_at
  end
  
end
