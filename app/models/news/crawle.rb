module News::Crawle
  
  def get_doc(url)
    p url
    seconds = rand(10..40)
    sleep(seconds)
    Nokogiri::HTML(URI.open(url))
  end
  
  def pedding_list(name = nil)
    ancestry = get_ancestry(name)
    query = Spina::Page.where.not(original_url: nil).where(published_at: nil).order(published_at: :desc)
    query = query.where(ancestry: ancestry) if name
    query.all
  end
  
  def save_page_detail(page, title, content = nil, lang = 'en', materialized_path = nil)
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
    
  def get_ancestry(ancestry_name)
    Spina::Page.find_by_name(ancestry_name).id
  end
  
  def get_ancestry_name(id)
    Spina::Page.find(id).name
  end
  
  def format_time(time)
    published_at = nil
    if time.include?('hour')
      published_at = i.hours.ago
    elsif time.include?('minute')
      published_at = i.minutes.ago
    elsif time.include?('day')
      published_at = i.days.ago
    elsif time =~ /\d+:\d+:\d+/
      published_at = time 
    else
      t = Time.strptime(time.strip, '%B %d, %Y')
      published_at = t + (rand(18.7..23.7) * 60 * 60)
    end
    published_at
  end
  
  def remove_class(doc)
    doc.css('[class]').each do |element|
      element.remove_attribute('class')
    end
    doc
  end
  
  def remove_empty(doc)
    doc.css('*').each do |element|
      next if element.name == 'img' && element['src']
      element.remove if element.text.strip.empty? && element.children.empty?
    end
    doc
  end
  
  def remove_link(doc)
    doc.css('a').each do |link|
      link.replace(link.content)
    end
    doc
  end
  
  def home_url(name)
    url = nil
    if name == 'CT'
      url = 'https://cointelegraph.com'
    elsif name = 'CD'
      url = 'https://www.coindesk.com'
    end
  end
  
end
