module Tool::Cmc
  
  def list(page)
    p url = "https://coinmarketcap.com/?page=#{page}"
    doc = get_doc(url)
    symbols = []
    doc.css('table.cmc-table > tbody > tr p.coin-item-symbol').each do |coin|
      symbol = coin.text
      symbols << symbol
    end
    
    doc.css('table.cmc-table > tbody > tr span.crypto-symbol').each do |coin|
      symbol = coin.text
      symbols << symbol
    end
    
    p symbols
    symbols
  end
  
  def update_top
    (1..3).each do |page|
      update_list_price(page)
    end
  end
  
  def update_list_price(page = 1)
    p '=' * 77
    url = "https://coinmarketcap.com/?page=#{page}"
    doc = get_doc(url, 13)
    doc.css('table.cmc-table > tbody > tr').each_with_index do |tr, i|
      symbol = tr.at('a.cmc-link .coin-item-symbol')
      symbol = tr.at('a.cmc-link .crypto-symbol') if symbol.nil?
      td = tr.css('td')[3].to_html
      price = td.match(/[\d,]+\.\d+/).to_s.gsub(',','').to_f
      next if price == 0
      lp = LatestPrice.find_by_symbol(symbol.text)
      next if lp.nil?
      lp.price = price
      lp.save
    end
    nil
  end

end