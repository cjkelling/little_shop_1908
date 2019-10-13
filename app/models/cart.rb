class Cart
  def initialize(initial_contents)
    @contents = initial_contents || Hash.new(0)
    @contents.default = 0
  end

  def count
    @contents.values.sum
  end

  def contents
    @contents.map do |item_id, _number_in_cart|
      Item.find(item_id)
    end
  end

  def item_count(item_id)
    @contents[item_id.to_s]
  end

  def subtotal(item_id)
    Item.find(item_id).price * @contents[item_id.to_s]
  end

  def grand_total
    total = 0
    @contents.each do |k, _v|
      total += subtotal(k)
    end
    total
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def subtract_item(item_id)
    @contents[item_id] -= 1
  end

  def inventory_limit?(item_id)
    item_count(item_id) == Item.find(item_id).inventory
  end
end
