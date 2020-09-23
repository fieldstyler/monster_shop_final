class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += subtotal_of(item_id)
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def item_meets_minimum_requirement?(item_id, discount)
    count_of(item_id) >= discount.minimum_items
  end

  def item_discounts_that_apply(item_id)
    applied_discounts = []
    Item.find(item_id).merchant.discounts.each do |discount|
      if item_meets_minimum_requirement?(item_id, discount) == true && (discount.merchant.id == Item.find(item_id).merchant.id)
        applied_discounts << discount
      end
    end
    applied_discounts
  end

  def greatest_discount(item_id)
    item = Item.find(item_id)
    1 - (item.merchant.discounts.where("minimum_items <= ?", count_of(item_id)).maximum(:percent_off).to_f / 100.00)
  end

  def subtotal_of(item_id)
    item = Item.find(item_id)
    if item_discounts_that_apply(item_id) == []
      @contents[item_id.to_s] * Item.find(item_id).price
    else
      @contents[item_id.to_s] * Item.find(item_id).price * greatest_discount(item_id)
    end
  end

end
