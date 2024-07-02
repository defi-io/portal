class AddColumnsToCoins < ActiveRecord::Migration[7.1]
  def change
    add_column :coins, :coin_name, :string
    add_column :coins, :full_name, :string
    add_column :coins, :algorithm, :string
    add_column :coins, :proof_type, :string
    add_column :coins, :sort_order, :integer
    add_column :coins, :total_coins_mined, :decimal, precision: 30, scale: 2
    add_column :coins, :circulating_supply, :decimal, precision: 30, scale: 2
    add_column :coins, :max_supply, :decimal, precision: 30, scale: 2
    add_column :coins, :launch_date, :date
    add_column :coins, :website, :string
    add_column :coins, :whitepaper, :string
    add_column :coins, :is_trading, :boolean, default: false
    add_column :coins, :description, :text
    add_column :coins, :industry, :string
  end
end
