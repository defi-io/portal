class LatestPricesController < ApplicationController
  
  def index
    @latest_prices = LatestPrice.order(id: :asc)
  end
  
end
