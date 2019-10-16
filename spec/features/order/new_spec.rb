require 'rails_helper'

RSpec.describe 'Checkout and order pages', type: :feature do
  before(:each) do
    @bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
    @chain = @bike_shop.items.create!(name: 'Chain', description: "It'll never break!", price: 50, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 2)
    @tire = @bike_shop.items.create!(name: 'Tire', description: 'This is a tire.', price: 30, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 7)
    visit "/items/#{@chain.id}"
    click_link 'Add Item to Cart'

    visit '/cart'

    click_link 'Checkout'
  end

  it 'can show cart details and shipping form' do
    within "#checkout-#{@chain.id}" do
      expect(page).to have_content(@chain.name)
      expect(page).to have_css("img[src*='#{@chain.image}']")
      expect(page).to have_content(@chain.merchant.name)
      expect(page).to have_content(@chain.price)
      expect(page).to have_content('Count: 1')
      expect(page).to have_content('Subtotal: $50.00')
    end

    expect(page).to have_content('Grand Total: $50.00')

    fill_in 'Customer name', with: 'Joe'
    fill_in 'Customer address', with: '123 Test Drive'
    fill_in 'Customer city', with: 'Denver'
    fill_in 'Customer state', with: 'CO'
    fill_in 'Customer zip', with: 80_128

    expect(page).to have_button('Create Order')
  end

  it 'can create and save order and redirect to order show page' do
    fill_in 'Customer name', with: 'Joe'
    fill_in 'Customer address', with: '123 Test Drive'
    fill_in 'Customer city', with: 'Denver'
    fill_in 'Customer state', with: 'CO'
    fill_in 'Customer zip', with: 80_128

    click_button 'Create Order'

    order = Order.last

    expect(current_path).to eq("/orders/#{order.id}")

    expect(page).to have_content("Order Date: #{order.created_at}")

    within "#order-#{@chain.id}" do
      expect(page).to have_content(@chain.name)
      expect(page).to have_css("img[src*='#{@chain.image}']")
      expect(page).to have_content(@chain.merchant.name)
      expect(page).to have_content(@chain.price)
      expect(page).to have_content('Count: 1')
      expect(page).to have_content('Subtotal: $50.00')
    end

    within "#shipping-#{order.id}" do
      expect(page).to have_content(order.customer_name)
      expect(page).to have_content(order.customer_address)
      expect(page).to have_content(order.customer_city)
      expect(page).to have_content(order.customer_state)
      expect(page).to have_content(order.customer_zip)
    end

    expect(page).to have_content('Grand Total: $50.00')
  end

  it 'can display flash message when all fields are not filled' do
    click_button 'Create Order'

    expect(page).to have_content("Customer name can't be blank, Customer address can't be blank, Customer city can't be blank, Customer state can't be blank, Customer zip can't be blank, Customer zip is the wrong length (should be 5 characters), and Customer zip is not a number")
  end
end
