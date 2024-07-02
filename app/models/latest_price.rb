class LatestPrice < ApplicationRecord
  include Tool::Cmc
  include News::Crawle
  
  belongs_to :coin
  
  def convert(to)
    self.usd / to.usd
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
  
  def latest
    symbols = []
    LatestPrice.where(updated: false).first(66).each do |l|
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