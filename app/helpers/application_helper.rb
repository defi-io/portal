module ApplicationHelper
  def title(title = nil)
    return "DeFi Insights: Crypto News, Trends from Cointelegraph" if action_name == 'ct'
    return "DeFi Insights: Crypto News, Trends from Theblock" if action_name == 'tb'
    return "DeFi Insights: Crypto News, Trends | DeFi.io" if action_name == 'homepage'
    current_page.title
  end
  
  def get_domain(url)
    URI.parse(url).host
  end
  
  def tab_class(flag)
    tab_css = "px-3 py-2 rounded-md bg-slate-50 cursor-pointer dark:bg-transparent dark:text-slate-300 dark:ring-1 dark:ring-slate-700"
    tab_css = "px-3 py-2 rounded-md bg-sky-500 text-white cursor-pointer" if flag
    tab_css
  end
  
  def lang(locale)
    lang = 'English'
    lang = '中文' if locale.to_s == 'zh-CN'
    lang
  end
  
  def pages
    Spina::Page.where(draft: false).where.not(published_at: nil).order(published_at: :desc)
  end
    
end
