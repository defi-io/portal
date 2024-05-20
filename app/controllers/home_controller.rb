class HomeController < ApplicationController
  layout 'default/application', only: [:ct, :tb]
  
  def index
  end
  
  def url
    Shortener::ShortenedUrl.generate(params[:url]) if params[:u] == '77'
    @domain = request.host_with_port
    @shortened_url = Shortener::ShortenedUrl.last
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
