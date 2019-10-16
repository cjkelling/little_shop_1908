require 'rails_helper'

RSpec.describe 'Order Index Page', type: :feature do
  before(:each) do
    @bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
    @chain = @bike_shop.items.create!(name: 'Chain', description: "It'll never break!", price: 50, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 5)
    @order = Order.create!(customer_name: 'Joe Schmo', customer_address: '123 Random Dr', customer_city: 'Denver', customer_state: 'CO', customer_zip: 80_128, order_number: 1234567890)
    @item_order = ItemOrder.create!(item_id: @chain.id, order_id: @order.id, price: 50.00, quantity: 1)
  end

  it 'displays information on all existing orders' do
    visit '/items'

    within 'nav' do
      click_link 'All Orders'
    end

    expect(current_path).to eq('/orders')

    expect(page).to have_link(@order.order_number)
    expect(page).to have_content(@order.customer_name)
    expect(page).to have_content(@order.customer_address)
    expect(page).to have_content(@order.customer_city)
    expect(page).to have_content(@order.customer_state)
    expect(page).to have_content(@order.customer_zip)
  end
end
