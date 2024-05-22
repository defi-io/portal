class ApplicationController < ActionController::Base
  before_action :set_locale
  
  def pages(name = nil)
    lang = I18n.locale
    ancestry = Spina::Page.find_by_name(name).id

    query = Spina::Page.where(draft: false).where.not(published_at: nil).order(published_at: :desc).limit 77
    query = query.where(ancestry: ancestry) if name
    query.all.select { |page| page.try("#{lang}_content").present? }
  end
  
  private

  def set_locale
    user_language = request.env['HTTP_ACCEPT_LANGUAGE'].split(',').first
    user_language = "en" unless user_language == "zh-CN"
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
