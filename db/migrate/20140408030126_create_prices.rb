class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.string :restaurant_id
      t.decimal :amount

      t.timestamps
    end
  end
end
