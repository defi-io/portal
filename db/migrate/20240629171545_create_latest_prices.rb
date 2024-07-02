class CreateLatestPrices < ActiveRecord::Migration[7.1]
  def change
    create_table :latest_prices do |t|
      t.string :symbol
      t.integer :coin_id
      t.decimal :price, precision: 20, scale: 12, default: 0

      t.timestamps
    end
    add_index :latest_prices, :coin_id, unique: true
    
  end
end
