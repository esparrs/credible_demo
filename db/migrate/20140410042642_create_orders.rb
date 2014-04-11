class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.text :name
      t.decimal :price
      
      t.timestamps
    end
  end
end
