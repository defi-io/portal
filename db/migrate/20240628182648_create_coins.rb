class CreateCoins < ActiveRecord::Migration[7.1]
  def change
    create_table :coins do |t|
      t.string :identity
      t.string :symbol
      t.string :name
      t.string :status

      t.timestamps
    end
  end
end
