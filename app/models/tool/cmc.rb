module Tool::Cmc
  
  def list(page)
    p url = "https://coinmarketcap.com/?page=#{page}"
    doc = get_doc(url)
    symbols = []
    doc.css('table.cmc-table > tbody > tr p.coin-item-symbol').each do |coin|
      p '=' * 77
      p symbol = coin.text
      symbols << symbol
    end
    
    doc.css('table.cmc-table > tbody > tr span.crypto-symbol').each do |coin|
      p '*' * 77
      p symbol = coin.text
      symbols << symbol
    end
    
    p symbols
    symbols
  end

end