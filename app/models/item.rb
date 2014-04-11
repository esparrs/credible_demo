class Item < ActiveRecord::Base
	has_many :prices
	belongs_to :value
	belongs_to :order

	accepts_nested_attributes_for :prices, :value

	def self.import(file)
  		s = open_spreadsheet(file)
  		(1..s.last_row).each do |i|
		   unless s.cell(i,4).nil?
		   		@value = Value.new
		   		for j in 3..s.last_column
		   			@item = @value.items.new 
		   			@item.update_attribute(:name, s.cell(i,j).strip)
		   			@price = @item.prices.new
		   			@price.update_attribute(:restaurant_id, s.cell(i,1).strip.to_i)
		   			@price.update_attribute(:amount, s.cell(i,2).strip.to_f)
		   			@price.save
		   			@item.save
		   		end
		   		# @price = @value.prices.new
		   		# @price.update_attribute(:restaurant_id, s.cell(i,1).strip.to_i)
		   		# @price.update_attribute(:amount, s.cell(i,2).strip.to_f)
		   		# @price.save
		   		@value.save
		   end
		   @item = Item.new 
		   @item.update_attribute(:name, s.cell(i,3).strip)
		   @price = @item.prices.new
		   @price.update_attribute(:restaurant_id, s.cell(i,1).strip.to_i)
		   @price.update_attribute(:amount, s.cell(i,2).strip.to_f)
		   @price.save
		   @item.save
  		end
	end

	def self.open_spreadsheet(file)
	  case File.extname(file.original_filename)
	  when ".csv" then Roo::CSV.new(file.path)
	  else raise "Unknown file type: #{file.original_filename}"
	  end
	end

	def search(order)
	end
end
