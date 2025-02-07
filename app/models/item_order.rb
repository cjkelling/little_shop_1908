class ItemOrder < ApplicationRecord
  belongs_to :item
  belongs_to :order
  validates_presence_of :item_id,
                        :order_id,
                        :price,
                        :quantity

  def subtotal
    price * quantity
  end
end
