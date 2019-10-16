require 'rails_helper'

RSpec.describe 'merchant show page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    end

    it 'I can see a merchants name, address, city, state, zip' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_content("Brian's Bike Shop")
      expect(page).to have_content("123 Bike Rd.\nRichmond, VA 23137")
    end

    it 'I can see a link to visit the merchant items' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_link("All #{@bike_shop.name} Items")

      click_on "All #{@bike_shop.name} Items"

      expect(current_path).to eq("/merchants/#{@bike_shop.id}/items")
    end

    it 'can show flash message when trying to visit nonexistent merchant show page' do
      visit '/merchants/2734027934'

      expect(page).to have_content('Merchant does not exist. Redirecting to Merchant index page.')

      expect(current_path).to eq('/merchants')
    end

    it 'cannot delete a merchant if they have items that have been ordered' do
      @chain = @bike_shop.items.create!(name: 'Chain', description: "It'll never break!", price: 50, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 2)
      @tire = @bike_shop.items.create!(name: 'Tire', description: 'This is a tire.', price: 30, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 7)
      visit "/items/#{@chain.id}"
      click_link 'Add Item to Cart'

      visit '/cart'

      click_link 'Checkout'

      fill_in 'Customer name', with: 'Joe'
      fill_in 'Customer address', with: '123 Test Drive'
      fill_in 'Customer city', with: 'Denver'
      fill_in 'Customer state', with: 'CO'
      fill_in 'Customer zip', with: 80128

      click_button 'Create Order'

      visit "/merchants/#{@bike_shop.id}"

      expect(page).to_not have_link('Delete Merchant')
    end

    it 'can show merchant statistics' do
      @chain = @bike_shop.items.create!(name: 'Chain', description: "It'll never break!", price: 50, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 2)
      @tire = @bike_shop.items.create!(name: 'Tire', description: 'This is a tire.', price: 30, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 7)

      order_1 = Order.create!(customer_name: "Joe Schmo", customer_address: "123 Random Dr", customer_city: "Denver", customer_state: "CO", customer_zip: 80128)
      order_2 = Order.create!(customer_name: "Sally Fields", customer_address: "468 Chestnut Ave", customer_city: "Denver", customer_state: "CO", customer_zip: 80128)
      order_3 = Order.create!(customer_name: "Bob Smith", customer_address: "728 Test Dr", customer_city: "Orlando", customer_state: "FL", customer_zip: 32738)

      ItemOrder.create!(item_id: @chain.id, order_id: order_1.id, price: 50.00, quantity: 1)
      ItemOrder.create!(item_id: @chain.id, order_id: order_2.id, price: 50.00, quantity: 1)
      ItemOrder.create!(item_id: @tire.id, order_id: order_3.id, price: 30.00, quantity: 1)

      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_content('Count of Items: 2')
      expect(page).to have_content('Average Price of Items: $40.00')
      expect(page).to have_content('Distinct Cities Where Items Have Been Ordered: Denver and Orlando')
    end

    it 'shows top 3 rated items' do
      chain = @bike_shop.items.create!(name: 'Chain', description: "It'll never break!", price: 50, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 2)
      tire = @bike_shop.items.create!(name: 'Tire', description: 'This is a tire.', price: 30, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 7)
      lock = @bike_shop.items.create!(name: 'Lock', description: 'This is a lock.', price: 15, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 5)
      helmet = @bike_shop.items.create!(name: 'Helmet', description: 'This is a helmet.', price: 35, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 5)
      review_1 = chain.reviews.create(title: "Awesome", content: "Really really awesome", rating: 5)
      review_2 = tire.reviews.create(title: "Not Great", content: "Stinks a lot", rating: 1)
      review_3 = lock.reviews.create(title: "Mediocre", content: "What can I say? Gets the job done I guess.", rating: 3)
      review_4 = helmet.reviews.create(title: "Mediocre", content: "What can I say? Gets the job done I guess.", rating: 4)

      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_content('Top 3 Highest Rated Items: Chain, Helmet, and Lock')
    end
  end
end
