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

  describe 'Navigation Bar' do
    it 'can click a link that takes user to discount index page' do
      visit merchants_path

      within 'nav' do
        click_link 'My Discounts'
      end
      expect(current_path).to eq('/merchant/discounts')
    end
  end

  describe 'Discount Index Page' do
    it 'can show all merchants and what discounts each merchant offers.' do
      visit '/merchant/discounts'
      @megan.discounts.each do |discount|
        expect(page).to have_content(discount.name)
      end
    end

    it 'displays a remove discount button next to each discount. When you click the button, it returns back to index page and the discount no longer exists' do
      visit '/merchant/discounts'
      within "#discount-#{@tenofffive.id}" do
        click_on "Remove Discount"
      end
      expect(current_path).to eq('/merchant/discounts')
      expect(page).to_not have_content(@tenofffive.name)
    end

    it 'displays an update discount button next to each discount. When you click the button, it brings you to a page with prepopulated info that you can submit' do
      visit '/merchant/discounts'
      within "#discount-#{@tenofffive.id}" do
        click_on "Update Discount"
      end
      expect(current_path).to eq("/merchant/discounts/#{@tenofffive.id}/edit")
      fill_in :name, with: "20 percent off 10 items or more"
      fill_in :percent_off, with: 20
      fill_in :minimum_items, with: 10

      click_on "Submit Updates"
      expect(current_path).to eq("/merchant/discounts")

      expect(page).to have_content("20 percent off 10 items or more")
    end
  end
end
