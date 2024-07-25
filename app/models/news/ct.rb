class News::Ct
  include News::Crawle
  include Tool::Deepl
  
  def list
    get_list(home_url('CT'))
  end
  
  def get_list(url)
    doc = get_doc(url)
    
    ancestry = get_ancestry('Cointelegraph')
    
    doc.css('article.post-card__article').each do |article|
      title = article.css('span.post-card__title').first.text
      link = article.css('header a').first['href']
      
      next unless link.include?('news')
      
      url = home_url('CT') + link
      
      original_page = Spina::Page.find_by_original_url(url)
      next if original_page
      
      p url
      
      page = Spina::Page.new
      page.original_url = url
      page.ancestry = ancestry
      save_page_detail(page, title)
    end
  end
  
  def list_to_detail(to_zh = true)
    pedding_list('Cointelegraph').each do |page|
      p "="*99, page.id, page.title
      get_detail(page)
      en_to_zh(page) if to_zh
    end
    nil
  end
  
  def get_detail(page)
    doc = get_doc(page.original_url)
    
    title = doc.css('h1.post__title').first.text
    
    published_at = get_published_at(doc)
    
    img_html_tag = get_img(doc)

    doc = doc.css('div.post__content-wrapper')
    
    doc = clean_doc(doc)
    
    content = img_html_tag + doc.first.to_html
    
    content = content.sub(' class="post__content-wrapper"', '')
    content = content.sub(' class="post-content relative"', '')
    content = content.gsub('<!---->', '')

    page.published_at = published_at
    
    save_page_detail(page, title, content)
  end
  
  def clean_doc(doc)
    remove_tags(doc, 'template')
    remove_attribute(doc, 'data-v-1239ec49')
    remove_attribute(doc, 'data-ct-non-breakable')

    hidden_img = doc.css('img.visually-hidden')
    hidden_img.each(&:remove) if hidden_img

    separator_line = doc.css('div.post__separator-line')
    separator_line.each(&:remove) if separator_line

    tags_list = doc.css('div.tags-list')
    tags_list.each(&:remove) if tags_list

    adslot = doc.css('div.adslot-after-article')
    adslot.each(&:remove) if adslot

    # History style
    shares_list = doc.search('div.shares-list__list')
    shares_list.each(&:remove) if shares_list
    
    related = doc.search('p strong em')
    related.each(&:remove) if related
    
    disclaimer = doc.search('p.post-content__disclaimer')
    disclaimer.each(&:remove) if disclaimer
    
    tags_list = doc.search('ul.tags-list__list')
    tags_list.each(&:remove) if tags_list
    
    reactions = doc.search('div.reactions_3eiuR')
    reactions.each(&:remove) if reactions
    
    remove_link(doc)
    doc
  end
  
  def get_img(doc)
    image_url = nil
 
    img_urls = doc.css('img').map { |img| img['src'] }

    img_urls.each do |img_url|
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
    else
      t = Time.strptime(time.strip, '%B %d, %Y')
      published_at = t + (rand(18.7..23.7) * 60 * 60)
    end
    published_at
  end
  
end
