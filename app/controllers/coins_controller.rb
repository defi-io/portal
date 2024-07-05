class CoinsController < ApplicationController
  before_action :set_coin, only: %i[ show ]

  def to_usd
    @latest_price = LatestPrice.find_by_symbol(params[:coin].upcase)
    if @latest_price.nil?
      shortened_url = Shortener::ShortenedUrl.find_by_unique_key(params[:coin])
      redirect_to shortened_url.url, allow_other_host: true 
    else 
      @price_cents = @latest_price.cents
      @currency = Currency.first
      @currencies = [:cny, :eur, :gbp, :aud, :cad, :jpy, :sgd, :hkd]
      Money.default_infinite_precision = true
      @coin = @latest_price.coin
      @title = "#{@latest_price.symbol} to USD, #{@latest_price.symbol} Price USD, #{@latest_price.symbol} USD"
    end
  end
  
  def to
    @latest_price = LatestPrice.find_by_symbol(params[:coin].upcase)
    @coin = @latest_price.coin
    @currency = Currency.first
    @current_currency = params[:currency].upcase
    @currencies = [:cny, :eur, :gbp, :aud, :cad, :jpy, :sgd, :hkd]
    @currencies.delete(params[:currency].to_sym)
    Money.add_rate("USD", @current_currency, @currency.try(params[:currency]))
    @price = Money.us_dollar(@latest_price.cents).exchange_to(@current_currency).to_d
    @title = "#{@latest_price.symbol} to #{@current_currency}, #{@latest_price.symbol} Price #{@current_currency}, #{@latest_price.symbol} #{@current_currency}"
  end
  
  def index
    @coins = Coin.per(20)
  end

  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coin
      @coin = Coin.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def coin_params
      params.fetch(:coin, {})
    end
end