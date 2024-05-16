class Ai::Tr
  
  def self.theblock_list
    last_url = 'https://www.theblock.co/latest'
    theblock_get_list(last_url)
    
    (1..5).each do |i|
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
    sleep(30)
    Nokogiri::HTML(URI.open(url))
  end
  
  def self.save_page_detail(page, title, content = nil, lang = 'en')
    page.view_template = 'show'
    
    page.assign_attributes(
        "#{lang}_content":[{ type: "Spina::Parts::Text", name: "text", content: content }],
    )   
    
    t = {locale: lang, title: title}
    page.translations.build(t)
    
    page.save!
  end
  
    def self.active_page
        locales = Spina.config.locales
        Spina::Page.live.order(:id).each do |page|
            next if page.id == 1
            p "#" * 66, page.id
            next if page.translations.count >= locales.size
            locales.each do |lang|
                p "=" * 55 + "translating #{lang}..."
                next if page.translations.find_by_locale(lang)
                t(page, lang)
                sleep(30)
            end
        end
    end

    def self.t(page, lang)
        title, content = title_and_content(page, lang)
        
        page.assign_attributes(
            "#{lang}_content":[{ type: "Spina::Parts::Text", name: "text", content: content }],
        )   
        
        materialized_path = "/#{lang}#{page.materialized_path}"
        t = {locale: lang, title: title, materialized_path: materialized_path}
        page.translations.new(t)
        
        page.save
    end 
        
    private
    def self.title_and_content(page, lang)
        title = page.translations.where(locale: 'en').first.title
        title_prompt = "Translate the following text into #{lang}: #{title}"
        translated_title = translate(title_prompt)
        
        sleep(15)
        
        content = page.en_content.first.content
        content_prompt = "Translate the following text into #{lang}, Preserve decode html tag: #{content}"
        translated_content = translate(content_prompt)

        return translated_title, translated_content
    end 

    def self.translate(prompt)
        p "-" * 33 + '>', prompt
        client = OpenAI::Client.new(access_token: 'sk-XXXXXXX')

        response = client.completions(
          parameters:
          {
            prompt: prompt,
            model: "text-davinci-003",
            temperature: 0.9,
            # n: 8192,
            max_tokens: 2048
          }
        )
        p "-" * 22 + '>'
        content = response['choices'][0]['text'].gsub("\n", '')
        p content
        content
    end
end