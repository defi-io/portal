class Currency < ApplicationRecord
  
  def get_currencies
    [:usd, :eur, :gbp, :aud, :cad, :jpy, :sgd, :hkd, :cny]
  end
  
  def search_currency(q = nil)
    get_currencies.select { |c| c =~ /#{q}/ }
  end

  def find_currencies
    currency = Currency.first
    currencies = [:eur, :gbp, :aud, :cad, :jpy, :sgd, :hkd, :cny]
    p rates = Cryptocompare::Price.find('USD', currencies)
    rates['USD'].each do |key, value|
      p key, value
      currency[key.downcase] = value
    end
    currency.save
  end
  
  def major_currencies(hash)
    hash.inject([]) do |array, (id, attributes)|
      priority = attributes[:priority]
      if priority && priority < 100
        array[priority] ||= []
        array[priority] << id
      end
      array
    end.compact.flatten
  end

  # Returns an array of all currency id
  def all_currencies(hash)
    hash.keys
  end
  
end
