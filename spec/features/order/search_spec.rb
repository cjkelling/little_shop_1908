require 'rails_helper'

RSpec.describe 'Search bar to find order show page', type: :feature do
  before(:each) do
    @bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
    @chain = @bike_shop.items.create!(name: 'Chain', description: "It'll never break!", price: 50, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 5)
    @order = Order.create!(customer_name: 'Joe Schmo', customer_address: '123 Random Dr', customer_city: 'Denver', customer_state: 'CO', customer_zip: 80_128, order_number: 1_234_567_890)
    @item_order = ItemOrder.create!(item_id: @chain.id, order_id: @order.id, price: 50.00, quantity: 1)
  end

  it 'can search for a created order' do
    visit '/items'

    fill_in 'Search', with: '1234567890'
    click_button 'Search for Order'

    expect(current_path).to eq("/verified_order")

    fill_in 'search', with: '1234560'
    click_button 'Search for Order'

    expect(page).to have_content('Order not found')

    expect(current_path).to eq('/items')
  end
end
