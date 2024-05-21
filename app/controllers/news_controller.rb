class NewsController < ApplicationController
  layout 'default/application'
  before_action :set_locale
  
  def index
    @pages = pages
    render 'default/pages/homepage'
  end
  
  def ct
    @pages = pages('Cointelegraph')
    render 'default/pages/homepage'
  end
  
  def tb
    @pages = pages('Theblock')
    render 'default/pages/homepage'
  end

end