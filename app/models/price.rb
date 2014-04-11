class Price < ActiveRecord::Base
	belongs_to :item
	belongs_to :value
	belongs_to :order

	accepts_nested_attributes_for :order, :item, :value
end
