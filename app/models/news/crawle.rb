module News::Crawle
  
  def get_doc(url)
    seconds = rand(10..40)
    sleep(seconds)
    Nokogiri::HTML(URI.open(url))
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
  
  def home_url(name)
    url = nil
    if name == 'CT'
      url = 'https://cointelegraph.com'
    end
  end
  
end
