class CreateValues < ActiveRecord::Migration
  def change
    create_table :values do |t|
      t.timestamps
    end

    create_table :prices do |t|
      t.belongs_to :item
      t.belongs_to :value
      t.integer :restaurant_id
      t.decimal :amount
      t.timestamps
    end
  end
end
