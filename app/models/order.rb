class Order < ActiveRecord::Base
	has_many :items
	has_many :values
	has_many :prices

	accepts_nested_attributes_for :prices, :values, :items 

	# will help us find the restaurant id and price
	def self.search(order)
		# make sure that order is a string
		order.to_str 
		# this splits our string into separate entries in an array
		list = order.split(/\W+/)
		# this hash will track our restaurant id and price
		specific_order = Hash.new
		# this hash will track our values
		value_tracker = Hash.new
		# iterating over all of the entries in the array
		(0..list.length-1).each do |i| 
			# getting the ids of the entries in order to access other attributes
			ids = Item.where(name: list[i]).ids
			# iterating over potential duplicates of names
			(1..ids.length-1).each do |j|
				# if this is the first entry, making sure to add everything to the hashes
				if i==0
					specific_order = {Item.find_by_id(ids[j]).prices.first.restaurant_id => Item.find_by_id(ids[j]).prices.first.amount}
					unless Item.find_by_id(ids[j]).value_id.nil?
						# if this is part of a value meal
						value_tracker = {Item.find_by_id(ids[j]).value_id => true}
					end
				else
					# after the first entry, should only proceed if we can find key in our hash
					if specific_order.has_key?(Item.find_by_id(ids[j]).prices.first.restaurant_id)
						# taking into account value meals
						unless Item.find_by_id(ids[j]).value_id.nil?
							# adding value meal to our value_track hash
							if value_tracker[Item.find_by_id(ids[j]).value_id].nil?
								tmp_price = (specific_order[Item.find_by_id(ids[j]).prices.first.restaurant_id].to_f + Item.find_by_id(ids[j]).prices.first.amount.to_f)
								specific_order[Item.find_by_id(ids[j]).prices.first.restaurant_id] = tmp_price
								value_tracker = {Item.find_by_id(ids[j]).value_id => true}
							end
							# we don't change price if value meal is already added
						end
						# adding to the price
						tmp_price = (specific_order[Item.find_by_id(ids[j]).prices.first.restaurant_id].to_f + Item.find_by_id(ids[j]).prices.first.amount.to_f)
						# changing price in the hash
						specific_order[Item.find_by_id(ids[j]).prices.first.restaurant_id] = tmp_price
					else 
						# if the order isn't possible
						return "Sorry, you're order isn't possible!"
					end
				end
			end
		end
		# sorting in descending order - want the lowest 
		specific_order.sort_by {|k,v| v}
		# this will be the lowest
		key, value = specific_order.first
		# boom. this is what we want.
		return key, value.to_f()
	end
end
