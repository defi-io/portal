class Article < Spina::Page
  def self.related(page)
    Article.where(ancestry: page.ancestry).where("id < ?", page.id).order(published_at: :desc).limit 10
  end
end