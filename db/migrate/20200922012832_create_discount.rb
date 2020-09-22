class CreateDiscount < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.string :name
      t.integer :percent_off
      t.integer :minimum_items
    end
  end
end
