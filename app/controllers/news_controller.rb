class NewsController < ApplicationController
  layout 'default/application'
  before_action :set_locale, :current_page
  
  def index
    last_page
    @pages = pages(@page)
    respond_to do |format|
      format.html { render 'default/pages/homepage' }
      format.turbo_stream
    end
  end
  
  def ct
    last_page('Cointelegraph')
    @pages = pages(@page, 'Cointelegraph')
    respond_to do |format|
      format.html { render 'default/pages/homepage' }
      format.turbo_stream { render 'news/index' }
    end
  end
  
  def tb
    last_page('Theblock')
    @pages = pages(@page, 'Theblock')
    respond_to do |format|
      format.html { render 'default/pages/homepage' }
      format.turbo_stream { render 'news/index' }
    end
  end
  
  def cd
    last_page('Coindesk')
    @pages = pages(@page, 'Coindesk')
    respond_to do |format|
      format.html { render 'default/pages/homepage' }
      format.turbo_stream { render 'news/index' }
    end
  end
  
  def dc
    last_page('Decrypt')
    @pages = pages(@page, 'Decrypt')
    respond_to do |format|
      format.html { render 'default/pages/homepage' }
      format.turbo_stream { render 'news/index' }
    end
  end
  
  def current_page
    @page = params[:page].to_i + 1
  end
  
  def next_page
    @page = params[:page].to_i + 1
  end
  
  def last_page(name = nil)
    @is_last = pages_count(params[:page], name)
  end

end