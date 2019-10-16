class Order < ApplicationRecord
  has_many :item_orders, dependent: :destroy
  has_many :items, through: :item_orders

  validates_presence_of :customer_name,
                        :customer_address,
                        :customer_city,
                        :customer_state,
                        :customer_zip

  validates_length_of :customer_zip, is: 5
  validates :customer_zip, numericality: true

  def grand_total
    item_orders.sum('price * quantity')
  end

  def self.search(search)
    Order.find_by(order_number: search)
  end
end
