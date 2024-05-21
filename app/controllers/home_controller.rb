class HomeController < ApplicationController
  layout 'default/application', only: [:ct, :tb]
  
  def index
  end
  
  def url
    Shortener::ShortenedUrl.generate(params[:url]) if params[:u] == '77'
    @domain = request.host_with_port
    @shortened_url = Shortener::ShortenedUrl.last
  end
  
end
