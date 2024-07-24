class News::Dl
  include News::Crawle
  include Tool::Deepl
  
  def list
    doc = get_doc(home_url('DL'))
    ancestry = get_ancestry('Dlnews')
    
    doc.css('a').each_with_index do |a, i|
      link = a['href']
      title = a.content
      next unless link.include?('/articles/')
      next if title.empty?
      next if link.split('/').size < 4
      
      url = home_url('DL') + link
      original_page = Spina::Page.find_by_original_url(url)
      next if original_page
      
      page = Spina::Page.new
      page.original_url = url
      page.ancestry = ancestry
      save_page_detail(page, title)
    end
    nil
  end
  
  def list_to_detail(to_zh = true)
    pedding_list('Dlnews').each do |page|
      p "="*99, page.id, page.title
      get_detail(page)
      en_to_zh(page) if to_zh
    end
    nil
  end
  
  def get_detail(page)
    doc = get_doc(page.original_url)
    desc = doc.at('div.image-info-text').text
    
    img_url = doc.at('div > picture > img')['src']
    
    doc = doc.at("div > article.article-body-wrapper")
    
    keywords = []
    doc.css('div div.border-b a.inline-flex').each do |a|
      keywords << a.content
    end
    
    doc = remove_related(doc)
    
    doc = remove_class(doc)
    doc = remove_link(doc)
    doc = remove_svg(doc)
    doc = remove_tags(doc, 'script')
    doc = remove_empty(doc)
  
    content = doc.to_html.sub('<article class="article-body-wrapper subtype-article">', '<article>')
    page.keywords = keywords.join(',')
    page.description = desc
    page.image_url = img_url
    page.published_at = Time.now
    save_page_detail(page, nil, content)
    nil
  end
  
  def remove_related(doc)
    related_topics = doc.at('div > div.border-b')
    related_topics.remove unless related_topics.nil?
    related_keywords = doc.css('div div a')
    return doc if related_keywords.nil?
    related_keywords.each do |a| 
      a.remove
    end
    doc
  end

end