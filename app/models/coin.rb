class Coin < ApplicationRecord
  include Tool::Cmc
  validates_uniqueness_of :identity, :symbol
  
  has_one :latest_price
  
  def self.coin_list
    @@coins = Cryptocompare::CoinList.all
  end

  def self.import
    i = 0
    @@coins['Data'].each do |key, value|
      puts "Key: #{key}"
      puts "Value: #{value['FullName']}"
      puts "isTrading: #{value['isTrading']}"
      puts "-" * 30
      p i += 1
      
      circulating_supply = value['CirculatingSupply']
      total_coins_mined = value['TotalCoinsMined']
      max_supply = value['MaxSupply']

      coin = Coin.new
      coin.identity = value['Id']
      coin.name = value['Name']
      coin.symbol = value['Symbol']
      coin.coin_name = value['CoinName']
      coin.full_name = value['FullName']
      coin.algorithm = value['Algorithm']
      coin.proof_type = value['ProofType']
      coin.sort_order = value['SortOrder']
      coin.circulating_supply = circulating_supply
      coin.total_coins_mined = total_coins_mined
      coin.max_supply = max_supply
      coin.launch_date = value['AssetLaunchDate']
      coin.website = value['AssetWebsiteUrl']
      coin.whitepaper = value['AssetWhitepaperUrl']
      coin.is_trading = value['IsTrading']
      coin.industry = value['Taxonomy']['Industry']
      coin.description = value['Description']
      begin
        coin.save
      rescue Exception => e
        next
      end
    end
  end

  def show_name
    (self.full_name ||= self.symbol).capitalize
  end
  
end