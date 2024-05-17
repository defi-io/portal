module Tool::Deepl
  
  def translate(texts = nil)
    translations = DeepL.translate texts, 'EN', 'ZH', tag_handling: 'html'
    title, content = translations.first.text, translations.last.text
    p title, content
    return title, content
  end
  
end