module Tool::Deepl
  
  def translate(texts = nil)
    translations = DeepL.translate texts, 'EN', 'ZH', tag_handling: 'html'
    title, content = translations.first.text, translations.last.text
    p title, content
    return title, content
  end
  
  def en_to_zh_list(name = nil)
    ancestry = get_ancestry(name)
    query = Spina::Page.where.not(original_url: nil).where.not(published_at: nil).order(published_at: :desc)
    query = query.where(ancestry: ancestry) if name
    query.all.each do |page|
      en_to_zh(page)
    end
    nil
  end
  
  def en_to_zh(page, size = 7000)
    p "="*99, page.id, page.title
    en_content = page.en_content.first.content

    return if en_content.nil?
    return if page.published_at < 2.day.ago 
    return if en_content.size > size
    return unless page.try('zh-CN_content').empty?
    
    texts = [page.title, en_content]
    title, content = translate(texts)

    materialized_path = page.materialized_path.gsub(get_ancestry_name(page.ancestry).downcase, 'zh-CN')
    save_page_detail(page, title, content, 'zh-CN', materialized_path)
    sleep(rand(5..15))
  end
  
end