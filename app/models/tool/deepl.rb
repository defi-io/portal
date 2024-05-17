module Tool::Deepl
  
  def translate(texts = nil)
    translations = DeepL.translate texts, 'EN', 'ZH', tag_handling: 'html'
    title, content = translations.first.text, translations.last.text
    p title, content
    return title, content
  end
  
  def en_to_zh
    Spina::Page.where.not(original_url: nil).where.not(published_at: nil).order(created_at: :desc).each do |page|
      p "="*99, page.id, page.title
      
      next unless page.try('zh-CN_content').empty?
      p page.en_content.first.content
      
      texts = [page.title, page.en_content.first.content]
      title, content = translate(texts)

      materialized_path = page.materialized_path.gsub(get_ancestry_name(page.ancestry).downcase, 'zh-CN')
      save_page_detail(page, title, content, 'zh-CN', materialized_path)
      sleep(rand(5..15))
    end
  end
  
end