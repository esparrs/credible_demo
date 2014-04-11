class Order < ActiveRecord::Base
	has_many :items
	has_many :values
	has_many :prices

	accepts_nested_attributes_for :prices, :values, :items 

	def self.search(order)
		order.to_str
		list = order.split(/\W+/)
		specific_order = Hash.new
		value_tracker = Hash.new
		(0..list.length-1).each do |i| 
			ids = Item.where(name: list[i]).ids
			(1..ids.length-1).each do |j|
				if i==0
					specific_order = {Item.find_by_id(ids[j]).prices.first.restaurant_id => Item.find_by_id(ids[j]).prices.first.amount}
					unless Item.find_by_id(ids[j]).value_id.nil?
						value_tracker = {Item.find_by_id(ids[j]).value_id => true}
					end
				else
					if specific_order.has_key?(Item.find_by_id(ids[j]).prices.first.restaurant_id)
						unless Item.find_by_id(ids[j]).value_id.nil?
							if value_tracker[Item.find_by_id(ids[j]).value_id].nil?
								tmp_price = (specific_order[Item.find_by_id(ids[j]).prices.first.restaurant_id].to_f + Item.find_by_id(ids[j]).prices.first.amount.to_f)
								specific_order[Item.find_by_id(ids[j]).prices.first.restaurant_id] = tmp_price
								value_tracker = {Item.find_by_id(ids[j]).value_id => true}
							end
						end
						tmp_price = (specific_order[Item.find_by_id(ids[j]).prices.first.restaurant_id].to_f + Item.find_by_id(ids[j]).prices.first.amount.to_f)
						specific_order[Item.find_by_id(ids[j]).prices.first.restaurant_id] = tmp_price
					else 
						return "Sorry, you're order isn't possible!"
					end
				end
			end
		end
		specific_order.sort_by {|k,v| v}
		key, value = specific_order.first
		return key, value.to_f()
	end
end
