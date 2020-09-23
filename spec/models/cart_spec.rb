require 'rails_helper'

RSpec.describe Cart do
  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50 )
      @tenofffive = @megan.discounts.create(name: "10 percent off 5 items or more",
                                            percent_off: 10,
                                            minimum_items: 5)
      @thirtyofffifteen = @megan.discounts.create(name: "30 percent off 15 items or more",
                                            percent_off: 30,
                                            minimum_items: 15)
      @cart = Cart.new({
        @ogre.id.to_s => 15,
        @giant.id.to_s => 5,
        @hippo.id.to_s => 8
        })
    end

    it '.contents' do
      expect(@cart.contents).to eq({
        @ogre.id.to_s => 15,
        @giant.id.to_s => 5,
        @hippo.id.to_s => 8
        })
    end

    it '.add_item()' do
      @cart.add_item(@hippo.id.to_s)

      expect(@cart.contents).to eq({
        @ogre.id.to_s => 15,
        @giant.id.to_s => 5,
        @hippo.id.to_s => 9
        })
    end

    it '.count' do
      expect(@cart.count).to eq(28)
    end

    it '.items' do
      expect(@cart.items).to eq([@ogre, @giant, @hippo])
    end

    it '.grand_total' do
      expect(@cart.grand_total).to eq(835)
    end

    it '.count_of()' do
      expect(@cart.count_of(@ogre.id)).to eq(15)
      expect(@cart.count_of(@giant.id)).to eq(5)
      expect(@cart.count_of(@hippo.id)).to eq(8)
    end

    it '.subtotal_of()' do
      expect(@cart.subtotal_of(@ogre.id)).to eq(210)
      expect(@cart.subtotal_of(@giant.id)).to eq(225)
      expect(@cart.subtotal_of(@hippo.id)).to eq(400)
    end

    it '.limit_reached?()' do
      expect(@cart.limit_reached?(@ogre.id)).to eq(false)
      expect(@cart.limit_reached?(@giant.id)).to eq(false)
      expect(@cart.limit_reached?(@hippo.id)).to eq(false)
    end

    it '.less_item()' do
      @cart.less_item(@giant.id.to_s)
      expect(@cart.count_of(@giant.id)).to eq(4)
    end

    it '.item_meets_minimum_requirement?()' do
      expect(@cart.item_meets_minimum_requirement?(@ogre.id, @tenofffive)).to eq(true)
      expect(@cart.item_meets_minimum_requirement?(@ogre.id, @thirtyofffifteen)).to eq(true)
      expect(@cart.item_meets_minimum_requirement?(@giant.id, @tenofffive)).to eq(true)
      expect(@cart.item_meets_minimum_requirement?(@giant.id, @thirtyofffifteen)).to eq(false)
      expect(@cart.item_meets_minimum_requirement?(@hippo.id, @tenofffive)).to eq(true)
      expect(@cart.item_meets_minimum_requirement?(@hippo.id, @thirtyofffifteen)).to eq(false)
    end

    it '.item_discount_applies()' do
      expect(@cart.item_discounts_that_apply(@ogre.id)).to eq([@tenofffive, @thirtyofffifteen])
      expect(@cart.item_discounts_that_apply(@giant.id)).to eq([@tenofffive])
      expect(@cart.item_discounts_that_apply(@hippo.id)).to eq([])
    end

    it '.greatest_discount()' do
      expect(@cart.greatest_discount(@ogre.id)).to eq(0.7)
      expect(@cart.greatest_discount(@giant.id)).to eq(0.9)
      expect(@cart.greatest_discount(@hippo.id)).to eq(1)
    end
  end
end
