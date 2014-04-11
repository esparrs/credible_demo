class AddBelongsToToItems < ActiveRecord::Migration
  def change
  	add_column :items, :value_id, :integer
  end
end
