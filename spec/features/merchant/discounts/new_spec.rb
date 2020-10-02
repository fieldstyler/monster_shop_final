# require 'rails_helper'

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

  describe 'Discount New Page' do
    it 'displays a form to create a new discount' do
      visit '/merchant/discounts/new'
      expect(page).to have_field(:name)
      expect(page).to have_field(:percent_off)
      expect(page).to have_field(:minimum_items)
    end

    it 'can create a new discount with all information filled out, taken back to merchant discount index page, and I can see my new discount' do
      visit '/merchant/discounts/new'
      fill_in :name, with: "20 percent off 10 items or more"
      fill_in :percent_off, with: 20
      fill_in :minimum_items, with: 10

      click_on "Create Discount"
      expect(current_path).to eq('/merchant/discounts')
      expect(page).to have_content("20 percent off 10 items or more")
    end

    it 'cant create a new discount with missing information' do
      visit '/merchant/discounts/new'
      fill_in :name, with: ""
      fill_in :percent_off, with: 20
      fill_in :minimum_items, with: 10

      click_on "Create Discount"
      expect(current_path).to eq('/merchant/discounts/new')
      expect(page).to have_content("Name can't be blank")
    end

    it 'cant create a new discount with incorrect input type' do
      visit '/merchant/discounts/new'
      fill_in :name, with: ""
      fill_in :percent_off, with: "whattup"
      fill_in :minimum_items, with: 10

      click_on "Create Discount"
      expect(current_path).to eq('/merchant/discounts/new')
      expect(page).to have_content("Name can't be blank and Percent off is not a number")
    end
  end
end
