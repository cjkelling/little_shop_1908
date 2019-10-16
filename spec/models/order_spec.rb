require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'relationships' do
    it { should have_many :item_orders }
    it { should have_many(:items).through(:item_orders) }
  end

  describe 'validations' do
    it { should validate_presence_of :customer_name }
    it { should validate_presence_of :customer_address }
    it { should validate_presence_of :customer_city }
    it { should validate_presence_of :customer_state }
    it { should validate_presence_of :customer_zip }
  end

  describe 'methods' do
    describe 'grand_total' do
      it 'shows grand total cost of items for that order' do
        bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
        chain = bike_shop.items.create!(name: 'Chain', description: "It'll never break!", price: 50, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 5)
        order = Order.create!(customer_name: 'Joe Schmo', customer_address: '123 Random Dr', customer_city: 'Denver', customer_state: 'CO', customer_zip: 80_128)
        ItemOrder.create!(item_id: chain.id, order_id: order.id, price: 50.00, quantity: 1)

        expect(order.grand_total).to eq(50)
      end
    end

    describe 'seach' do
      it 'seaches for orders by order number' do
        bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
        chain = bike_shop.items.create!(name: 'Chain', description: "It'll never break!", price: 50, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 5)
        order = Order.create!(customer_name: 'Joe Schmo', customer_address: '123 Random Dr', customer_city: 'Denver', customer_state: 'CO', customer_zip: 80_128, order_number: 1234567890)
        ItemOrder.create!(item_id: chain.id, order_id: order.id, price: 50.00, quantity: 1)

        expect(Order.search(1234567890)).to eq(order)
      end
    end
  end
end
