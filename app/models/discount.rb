class Discount < ApplicationRecord
  validates_presence_of :name, :percent_off, :minimum_items
  validates_numericality_of :percent_off, :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  validates_numericality_of :minimum_items, :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100
  belongs_to :merchant
end
