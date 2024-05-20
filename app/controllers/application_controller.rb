class ApplicationController < ActionController::Base
  before_action :set_locale
  
  def pages(name = nil)
    ancestry = Spina::Page.find_by_name(name).id

    query = Spina::Page.where(draft: false).where.not(published_at: nil).order(published_at: :desc)
    query = query.where(ancestry: ancestry) if name
    query.all
  end
  
  private

  def set_locale
    if params[:locale]
      I18n.locale = params[:locale] || I18n.default_locale
      cookies[:locale] = params[:locale]
    else
      I18n.locale = cookies[:locale]
    end
  end
  
end
