class Item < ActiveRecord::Base
	has_many :prices
	belongs_to :value
	belongs_to :order

	accepts_nested_attributes_for :prices, :value

	# for taking care of the csv file
	def self.import(file)
  		# setting our spreadsheet
  		s = open_spreadsheet(file)
  		# iterating over all rows
  		# we care about the item's price and restaurant id - that's what we'll
  		(1..s.last_row).each do |i|
		   # this will tell us if there is a value meal in our midst
		   unless s.cell(i,4).nil?
		   		# tmp var for value meal
		   		@value = Value.new
		   		# iterate over remaining columns - all items in value meal
		   		for j in 3..s.last_column
		   			@item = @value.items.new 
		   			@item.update_attribute(:name, s.cell(i,j).strip)
		   			@price = @item.prices.new
		   			@price.update_attribute(:restaurant_id, s.cell(i,1).strip.to_i)
		   			@price.update_attribute(:amount, s.cell(i,2).strip.to_f)
		   			@price.save
		   			@item.save
		   		end
		   		@value.save
		   end
		   # if not part of value meal
		   @item = Item.new 
		   @item.update_attribute(:name, s.cell(i,3).strip)
		   @price = @item.prices.new
		   @price.update_attribute(:restaurant_id, s.cell(i,1).strip.to_i) 
		   @price.update_attribute(:amount, s.cell(i,2).strip.to_f)
		   @price.save
		   @item.save
  		end
	end

	# this helper fxn is for opening our csv file
	def self.open_spreadsheet(file)
	  case File.extname(file.original_filename)
	  when ".csv" then Roo::CSV.new(file.path)
	  else raise "Unknown file type: #{file.original_filename}"
	  end
	end
end
