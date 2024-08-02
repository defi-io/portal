class Insight::Paradigm
  include News::Crawle
  include Tool::Deepl
  
  def list
    doc = get_doc("#{home_url('PD')}/writing")
    ancestry = get_child_ancestry('Paradigm')
    doc.css('div.Writing_writing__post___l5Qs > a').each_with_index do |a, i|
      title, link = a.at('h2').text, a['href']
      p '='*77, title, link
      url = home_url('PD') + link
      original_page = Spina::Page.find_by_original_url(url)
      next if original_page
      
      page = Spina::Page.new
      page.original_url = url
      page.ancestry = ancestry
      page.keywords = "Paradigm"
      save_page_detail(page, title)
    end
    nil
  end
  
  def list_to_detail
    pedding_children('Paradigm').each do |page|
      p "="*99, page.id, page.title
      get_detail(page)
      en_to_zh(page, 15000)
      break
    end
    nil
  end
  
  
  def get_detail(page = nil)
    doc = get_doc(page.original_url)
    time_arthor = doc.at('p.Post_post__details__W3e0e').content
    published_at = time_arthor.split('|').first
    author = time_arthor.split('|').last
    
    doc = doc.at('div.Post_post__content__dmuW4')
    doc = clear_html(doc)
    content = doc.to_html
    content = content.gsub('"/static/', '"https://www.paradigm.xyz/static/')
    content = content.sub(' class="Post_post__content__dmuW4"', '')
    page.author = author
    page.published_at = Time.parse(published_at)
    save_page_detail(page, nil, content)
    nil
  end
  
  def clear_html(doc)
    doc = remove_class(doc)
    doc = remove_link(doc)
    doc = remove_tags(doc, 'style')
    doc = remove_attribute(doc, 'id')
    doc = remove_attribute(doc, 'style')
    doc = remove_empty(doc)
    doc.css('comment()').remove
    doc
  end
  
end