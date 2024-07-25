class ApplicationController < ActionController::Base
  before_action :set_locale
  
  def pages(page, name = nil)
    lang = I18n.locale
    limit = 15
    query = Spina::Page.where(draft: false).where.not(published_at: nil).order(published_at: :desc).offset((page - 1) * limit).limit limit    
    if name
      ancestry = Spina::Page.find_by_name(name).id
      query = query.where(ancestry: ancestry) 
    end
    query.all.select { |page| page.try("#{lang}_content").present? }
  end
  
  def pages_count(page, name = nil)
    limit = 15
    query = Spina::Page.where(draft: false).where.not(published_at: nil)
    if name
      ancestry = Spina::Page.find_by_name(name).id
      query = query.where(ancestry: ancestry) 
    end
    offset = limit * (page.to_i + 1)
    offset >= query.count
  end
  
  private

  def set_locale
    http_accept_language = request.env['HTTP_ACCEPT_LANGUAGE']
    if http_accept_language.nil?
      user_language = "en"
    else
      user_language = http_accept_language.split(',').first
      user_language = "en" unless user_language == "zh-CN"
    end
    if params[:locale]
      I18n.locale = params[:locale]
      cookies[:locale] = params[:locale]
    elsif cookies[:locale]
      I18n.locale = cookies[:locale]
    else
      I18n.locale = user_language || I18n.default_locale 
    end
  end
  
end
