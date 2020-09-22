class Discount < ApplicationRecord
  validates_presence_of :name, :percent_off, :minimum_items

  belongs_to :merchant
end
