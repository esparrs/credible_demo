class Value < ActiveRecord::Base
	has_many :prices
	has_many :items
	belongs_to :order

	accepts_nested_attributes_for :prices, :items
end
