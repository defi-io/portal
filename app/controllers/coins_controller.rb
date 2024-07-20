class CoinsController < ApplicationController
  before_action :set_coin, only: %i[ show ]
  before_action :latest_price, only: %i[ convert calcalate to ]
  before_action :set_currencies, only: %i[ convert calcalate ]
  before_action :multi_currencies, only: %i[ convert calcalate to ]
  before_action :total_amount, only: %i[ convert calcalate ]
  layout false, only: [:calcalate, :search_coin, :search_currency]

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
    @coin = @latest_price.coin
    @currencies = [:cny, :eur, :gbp, :aud, :cad, :jpy, :sgd, :hkd]
    @currencies.delete(params[:to].to_sym)
    @title = "#{@latest_price.symbol} to #{@current_currency}, #{@latest_price.symbol} Price #{@current_currency}, #{@latest_price.symbol} #{@current_currency}"
  end
  
  def convert
  end
  
  def calcalate
    @is_valid = false
    amount = params[:amount]
    if amount.empty?
      @tip = "An amount needs to be entered."
    elsif amount.to_f <= 0
      @tip = "Amount must be greater than zero."
    else
      @is_valid = true
    end
  end
  
  def search_coin
    @coins = LatestPrice.search(params[:from]).limit(10)
  end
  
  def search_currency
    @currencies = Currency.new.search_currency(params[:to].downcase)
  end
  
  def index
    @coins = Coin.limit(100)
  end

  def show
  end

  private
    def set_currencies
      @currencies = [:usd, :cny, :eur, :gbp, :aud, :cad, :jpy, :sgd, :hkd]
      @currencies.delete(params[:to].downcase.to_sym)
    end
  
    def latest_price
      @latest_price = LatestPrice.find_by_symbol(params[:from].upcase)
      if @latest_price.nil?
        @latest_price = LatestPrice.search(params[:from]).first
      end
    end
  
    def multi_currencies
      @currency = Currency.first
      @current_currency = params[:to].upcase
      Money.add_rate("USD", @current_currency, @currency.try(params[:to].downcase))
      @price = Money.us_dollar(@latest_price.cents).exchange_to(@current_currency).to_d
    end
    
    def total_amount
      @total_amount = @latest_price.other_currency_amount(params[:amount].to_d, @price)
    end
  
    def set_coin
      @coin = Coin.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def coin_params
      params.fetch(:coin, {})
    end
end