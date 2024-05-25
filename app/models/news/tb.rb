class News::Tb
  include News::Crawle
  include Tool::Deepl
  
  def list
    last_url = 'https://www.theblock.co/latest'
    get_list(last_url)

    (1..1).each do |i|
      url = "https://www.theblock.co/latest?start=#{10 * i}"
      get_list(url)
    end
  end
  
  def get_list(url)
    doc = get_doc(url)
    
    ancestry = get_ancestry('Theblock')
    
    doc.css('div.articles article').each do |article|
      title = article.css('h2').first.text
      link = article.css('a').first['href']
      url = "https://www.theblock.co#{link}"
      original_page = Spina::Page.find_by_original_url(url)
      next if original_page
      
      page = Spina::Page.new
      page.original_url = url
      page.ancestry = ancestry
      save_page_detail(page, title)
    end
  end
  
  def list_to_detail(to_zh = true)
    pedding_list('Theblock').each do |page|
      p "="*99, page.id, page.title, page.original_url
      get_detail(page)
      en_to_zh(page) if to_zh
    end
  end
  
  def get_detail(page)    
    doc = get_doc(page.original_url)
    
    doc = clean_doc(doc)
    
    title = doc.css('h1').first.text
    published_at = doc.css('div.timestamp').first.text.split("•").last
    image = doc.css('div.articleFeatureImage img').first.to_html
    quick_take = doc.search('div.quickTake').first.to_html
    article = doc.search('div#articleContent').first.to_html
    
    content = (image + quick_take + article).gsub(' data-v-f87c67ca', '')
    page.published_at = Time.parse(published_at)
    save_page_detail(page, title, content, 'en')
  end
  
  def clean_doc(doc)
    newsletter_box = doc.search('div.newsletterBox')
    newsletter_box.remove.each(&:remove) if newsletter_box
    
    svg = doc.search('svg')
    svg.remove.each(&:remove) if svg
    
    google_image = doc.search('img.google-news-featured-image')
    google_image.remove.each(&:remove) if google_image
    
    article_charts = doc.search('section.articleCharts')
    article_charts.remove.each(&:remove) if article_charts

    copyright = doc.search('span.copyright').first
    copyright.remove if copyright
    
    doc.css('a').each do |link|
      link.replace(link.content)
    end
    
    doc
  end
  
end