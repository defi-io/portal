class NewsController < Spina::PagesController
  layout 'default/application'
  before_action :set_locale
  
  def homepage
    @pages = Spina::Page.where(draft: false).where.not(published_at: nil).order(published_at: :desc)
    render 'default/pages/homepage'
  end
  
  def show
    super
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