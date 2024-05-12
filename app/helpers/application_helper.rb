module ApplicationHelper
  def title(title = nil)
    return "DeFi Insights: Crypto News, Trends | DeFi.io" if current_page.title == 'Homepage'
    current_page.title
  end
end
