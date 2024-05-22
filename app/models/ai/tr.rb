class Ai::Tr
  extend Tool::Deepl
  
  def self.theblock_list
    last_url = 'https://www.theblock.co/latest'
    theblock_get_list(last_url)
    
    (1..1).each do |i|
      url = "https://www.theblock.co/latest?start=#{10 * i}"
      theblock_get_list(url)
    end
  end
  
  def self.theblock_get_list(url)
    doc = get_doc(url)
    
    ancestry = get_ancestry('Theblock')
    
    doc.css('div.headline').each do |headline|
      title = headline.css('h2').first.text
      link = headline.css('a').first['href']
      url = "https://www.theblock.co#{link}"
      original_page = Spina::Page.find_by_original_url(url)
      next if original_page
      
      page = Spina::Page.new
      page.original_url = url
      page.ancestry = ancestry
      save_page_detail(page, title)
    end
    
  end
  
  def self.get_ancestry(ancestry_name)
    Spina::Page.find_by_name(ancestry_name).id
  end
  
  def self.theblock_list_to_detail
    Spina::Page.where.not(original_url: nil).where(published_at: nil).each do |page|
      p "="*99, page.id, page.title
      
      get_page_detail(page)
    end
  end
  
  def self.theblock_en_to_zh
    Spina::Page.where.not(original_url: nil).where.not(published_at: nil).each do |page|
      p "="*99, page.id, page.title
      
      next unless page.try('zh-CN_content').empty?
      p page.en_content.first.content
      
      texts = [page.title, page.en_content.first.content]
      title, content = translate(texts)

      materialized_path = page.materialized_path.gsub('theblock', 'zh-CN')
      save_page_detail(page, title, content, 'zh-CN', materialized_path)
      sleep(rand(5..15))
      
    end
  end
  
  def self.get_page_detail(page)    
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
  
  def self.clean_doc(doc)
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
  
  def self.get_doc(url)
    p seconds = rand(10..40)
    sleep(seconds)
    Nokogiri::HTML(URI.open(url))
  end
  
  def self.save_page_detail(page, title, content = nil, lang = 'en', materialized_path = nil)
    lang_content_label = "#{lang}_content"
    page.view_template = 'show'
    
    if page.try(lang_content_label).first.nil?
      page.assign_attributes(
        "#{lang_content_label}": [{ type: "Spina::Parts::Text", name: "text", content: content }],
      )   
  
      t = {locale: lang, title: title, materialized_path: materialized_path}
      page.translations.build(t)
    else
      page.try(lang_content_label).first.content = content
    end
    
    page.save!
  end
    
end