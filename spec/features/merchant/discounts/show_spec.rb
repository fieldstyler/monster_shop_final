require 'rails_helper'

RSpec.describe "Merchant Discounts Index Page" do
  before :each do
    @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @merch_user = @megan.users.create(name: "Tyler",
                                      address: '123 something st',
                                      city: 'Denver',
                                      state: 'CO',
                                      zip: 23456,
                                      email: 'merchant',
                                      password: '123')
    @tenofffive = @megan.discounts.create(name: "10 percent off 5 items or more",
                                          percent_off: 10,
                                          minimum_items: 5)
    @thirtyofffifteen = @megan.discounts.create(name: "30 percent off 15 items or more",
                                          percent_off: 30,
                                          minimum_items: 15)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merch_user)
  end

  describe 'Discount Show Page' do
    it 'can display discounts name, percent off, and minimum quantity needed for discount to apply' do
      visit "/merchant/discounts/#{@tenofffive.id}"
      expect(page).to have_content(@tenofffive.name)
      expect(page).to have_content(@tenofffive.percent_off)
      expect(page).to have_content(@tenofffive.minimum_items)
    end
  end
end
