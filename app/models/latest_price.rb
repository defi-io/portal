class LatestPrice < ApplicationRecord
  include Tool::Cmc
  include News::Crawle
  include Tool::Money
  
  belongs_to :coin
  
  def cents
    self.price * 100
  end
  
  def total_amount(amount)
    to_round(self.price * amount)
  end
  
  def other_currency_amount(amount, price)
    to_round(price * amount)
  end
  
  def other_amount(currency, amount = 1)
    c = Currency.first
    Money.add_rate("USD", currency.upcase, c.try(currency.downcase))
    exchange_to = Money.us_dollar(self.cents).exchange_to(currency.upcase).to_d
    to_round(exchange_to * amount.to_d)
  end
  
  def self.search(q)
    # return active if q.nil?
    search_term = "#{q.strip}%"
    where("symbol ILIKE ?", search_term).order(id: :asc)
  end
  
  def top(page = 1)
    symbols = list(page)
    symbols.each do |symbol|
      c = LatestPrice.find_by_symbol(symbol)
      next if c
      coin = Coin.find_by_symbol(symbol)
      next if coin.nil?
      LatestPrice.create(coin_id: coin.id, symbol: symbol)
    end
  end
  
  # Cryptocompare API
  def low_price
    symbols = []
    LatestPrice.where("price < 0.01").first(66).each do |l|
      p '-' * 55, l.id, l.symbol, l.price
      symbols << l.symbol
    end
    p symbols
    prices = Cryptocompare::Price.find(symbols, 'USD')
    p prices 
    update_price(prices)
  end
  
  def update_price(prices = nil)
    prices.each do |key, value|
      price = value['USD']
      p key, price
      coin = LatestPrice.find_by_symbol(key)
      coin.price = price
      coin.updated = true
      coin.save
    end
  end
  
end
