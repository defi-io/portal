module ApplicationHelper
  def title(title = nil)
    return "DeFi Insights: Crypto News, Trends | DeFi.io" if current_page.title == 'Homepage'
    current_page.title
  end
  
  def get_domain(url)
    URI.parse(url).host
  end
  
  def pages
    Spina::Page.where(draft: false).where.not(published_at: nil).order(published_at: :desc)
  end
end
