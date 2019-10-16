require 'rails_helper'

describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe 'relationships' do
    it { should have_many :items }
  end

  describe 'methods' do
    before(:each) do
      @bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @chain = @bike_shop.items.create!(name: 'Chain', description: "It'll never break!", price: 50, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 5)
      @tire = @bike_shop.items.create!(name: 'Tire', description: 'This is a tire.', price: 30, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 2)
      @lock = @bike_shop.items.create!(name: 'Lock', description: 'This is a lock.', price: 15, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 5)
      @helmet = @bike_shop.items.create!(name: 'Helmet', description: 'This is a helmet.', price: 35, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 5)
      @order = Order.create!(customer_name: 'Joe Schmo', customer_address: '123 Random Dr', customer_city: 'Denver', customer_state: 'CO', customer_zip: 80_128)
      @item_order = ItemOrder.create!(item_id: @chain.id, order_id: @order.id, price: 50.00, quantity: 1)
    end

    describe 'has_orders?' do
      it 'shows if merchants have items being ordered' do
        expect(@bike_shop.has_orders?).to eq(true)
      end
    end

    describe 'count_of_items' do
      it 'shows the count of merchants items' do
        expect(@bike_shop.count_of_items).to eq(4)
      end
    end

    describe 'average_price' do
      it 'shows the average price of items for the merchant' do
        expect(@bike_shop.average_price).to eq(32.5)
      end
    end

    describe 'distinct_cities' do
      it 'shows the distinct cities ordered from for the merchant' do
        expect(@bike_shop.distinct_cities.to_sentence).to eq('Denver')
      end
    end

    describe 'Top 3 Rated Items' do
      it 'shows the merchants top 3 rated items' do
        review_1 = @chain.reviews.create(title: "Awesome", content: "Really really awesome", rating: 5)
        review_2 = @tire.reviews.create(title: "Not Great", content: "Stinks a lot", rating: 1)
        review_3 = @lock.reviews.create(title: "Mediocre", content: "What can I say? Gets the job done I guess.", rating: 3)
        review_4 = @helmet.reviews.create(title: "Mediocre", content: "What can I say? Gets the job done I guess.", rating: 4)

        expect(@bike_shop.top_items).to eq('Chain, Helmet, and Lock')
      end
    end
  end
end
