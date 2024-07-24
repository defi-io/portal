class News::Cd
  include News::Crawle
  include Tool::Deepl
  
  def list
    home_url = home_url('CD')
    channels = ['markets', 'business', 'policy', 'tech']
    channels.each do |c|
      get_list("#{home_url}/#{c}", c)
    end
  end
  
  def get_list(url, channel)
    p "=" * 99
    doc = get_doc(url)
    ancestry = get_ancestry('Coindesk')
    
    doc.css('a').each do |a|     

      title = a.text
      link = a['href']
      
      next if link.nil? || link == "/#{channel}/"
      next unless link.starts_with?("/#{channel}/")
      next if title.empty?
      
      url = home_url('CD') + link
      
      original_page = Spina::Page.find_by_original_url(url)
      next if original_page
      
      p "-"*77 
      p title, link
      
      page = Spina::Page.new
      page.original_url = url
      page.ancestry = ancestry
      save_page_detail(page, title)
    end
  end
  
  def list_to_detail(to_zh = true)
    pedding_list('Coindesk').each do |page|
      p "="*99, page.id, page.title
      get_detail(page)
      en_to_zh(page) if to_zh
    end
    nil
  end
  
  def get_detail(page)    
    doc = get_doc(page.original_url)

    img = doc.css('picture img').first
    if img['width'].nil? || img['width'].to_i < 200
      img =''
    else
      img = img.to_html
    end
    
    page.published_at = format_time(doc.css('div.at-created span').first.text)

    doc = doc.at('section.at-body div.at-content-wrapper')
    video = doc.at('div.eFFIxC')
    video.remove if video
    
    doc = remove_attribute(doc, 'data-submodule-name')
    doc = remove_class(doc)
    doc = remove_empty(doc)
    doc = remove_link(doc)
    body = clean_doc(doc).to_html
    body = body.sub(' class="at-content-wrapper"', '')
    content = img + body
    
    save_page_detail(page, nil, content)
  end
  
  def clean_doc(doc)
    doc.css('li div').each do |div|
      div.replace(div.content)
    end
    
    if doc.css('div div.at-text p a').first
      doc.css('div div.at-text p i').each do |element|
        element.remove
      end
    end
    doc
  end
  
end