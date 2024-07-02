class AddUpdatedToLatestPrices < ActiveRecord::Migration[7.1]
  def change
    add_column :latest_prices, :updated, :boolean, default: false
  end
end
