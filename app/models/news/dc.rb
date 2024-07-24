class News::Dc
  include News::Crawle
  include Tool::Deepl
  
  def list
    url = home_url('DC') + "/news"
    doc = get_doc(url)
    ancestry = get_ancestry('Decrypt')
    doc.css('main a').each do |a|
      p '-'*33
      p is_matched = a['href'].start_with?(/\/\d+\//)
      if is_matched
        p title = a.content
        url = a['href']

        p original_url = home_url('DC') + url
        
        original_page = Spina::Page.find_by_original_url(original_url)
        next if original_page
    
        page = Spina::Page.new
        page.original_url = original_url
        page.ancestry = ancestry
        save_page_detail(page, title)
      end
    end
    nil
  end
  
  def list_to_detail(to_zh = true)
    pedding_list('Decrypt').each do |page|
      p "="*99, page.id, page.title
      get_detail(page)
      en_to_zh(page) if to_zh
    end
    nil
  end
  
  def get_detail(page)
    doc = get_doc(page.original_url)

    page.published_at = format_time(doc.at('div > span > time').attr('datetime'))
    title = doc.at('header > div > h1').content
    h2 = doc.at('header > div > h2').remove_class.to_html
    img_url = get_img(doc)
    page.image_url = img_url
    
    article = h2
    doc = doc.css('div.grid-cols-1 > p.font-meta-serif-pro').each_with_index do |paragraph, i|
      paragraph = paragraph.remove_class
      paragraph = remove_link(paragraph)
      # paragraph = remove_span(paragraph)
      paragraph = remove_empty(paragraph)
      p paragraph.to_html
      article += paragraph.to_html.chomp
    end
    save_page_detail(page, title, article, 'en')
  end
  
  def get_img(doc)
    img = doc.at('div > figure > div img')['srcset']
    img_url = img.scan(/https?:\/\/[^\s]+/).first
    img_url
  end
  
end

