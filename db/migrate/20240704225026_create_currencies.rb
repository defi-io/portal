class CreateCurrencies < ActiveRecord::Migration[7.1]
  def change
    create_table :currencies do |t|
      t.decimal :usd, precision: 20, scale: 7, default: 0
      t.decimal :eur, precision: 20, scale: 7, default: 0
      t.decimal :gbp, precision: 20, scale: 7, default: 0
      t.decimal :aud, precision: 20, scale: 7, default: 0
      t.decimal :cad, precision: 20, scale: 7, default: 0
      t.decimal :jpy, precision: 20, scale: 7, default: 0
      t.decimal :sgd, precision: 20, scale: 7, default: 0
      t.decimal :hkd, precision: 20, scale: 7, default: 0
      t.decimal :cny, precision: 20, scale: 7, default: 0

      t.timestamps
    end
  end
end
