class Insight::Mc
  include News::Crawle
  include Tool::Deepl
  
  def list
    doc = get_doc(home_url('MC'))
    ancestry = get_child_ancestry('Multicoin')
    doc.css('ul > li a').each_with_index do |a, i|
      link = a['href']
      title = a.content
      next if link.nil?
      next unless (link.start_with?('/2023') | link.start_with?('/2024'))

      p i, title, link
      url = home_url('MC') + link
      original_page = Spina::Page.find_by_original_url(url)
      next if original_page
      
      page = Spina::Page.new
      page.original_url = url
      page.ancestry = ancestry
      page.keywords = "Multicoin"
      save_page_detail(page, title)
    end
    nil
  end
  
  def list_to_detail(to_zh = true)
    pedding_children('Multicoin').each do |page|
      p "="*99, page.id, page.title
      get_detail(page)
      en_to_zh(page, 30000) if to_zh
    end
    nil
  end
  
  def get_detail(page)
    doc = get_doc(page.original_url, 15)
    time = doc.at('div.styles__StyledDate-sc-ff97tw-6').text
    published_at = time.split('|').first
    
    doc = doc.at('div.styles__StyledContent-sc-1dmjz9w-2')
    doc = clear_html(doc)
    content = doc.to_html.sub(' class="styles__StyledContent-sc-1dmjz9w-2 krrlRu"', '')
    page.published_at = Time.parse(published_at)
    save_page_detail(page, nil, content)
  end
  
  def clear_html(doc)
    doc = remove_class(doc)
    doc = remove_link(doc)
    doc = remove_attribute(doc, 'id')
    doc = remove_attribute(doc, 'start')
    doc = remove_empty(doc)
  end
  
end