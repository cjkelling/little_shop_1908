require 'rails_helper'

describe ItemOrder, type: :model do
  describe 'validations' do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
  end

  describe 'relationships' do
    it { should belong_to :item }
    it { should belong_to :order }
  end

  describe 'methods' do
    describe 'subtotal' do
      it 'shows subtotal cost of items for that order' do
        bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
        chain = bike_shop.items.create!(name: 'Chain', description: "It'll never break!", price: 50, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 2)
        order = Order.create!(customer_name: 'Joe Schmo', customer_address: '123 Random Dr', customer_city: 'Denver', customer_state: 'CO', customer_zip: 80_128)
        item_order = ItemOrder.create!(item_id: chain.id, order_id: order.id, price: 50.00, quantity: 1)

        expect(item_order.subtotal).to eq(50)
      end
    end
  end
end
