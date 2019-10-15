class OrdersController < ApplicationController
  def new
  end

  def create
    order = Order.create(order_params)
    if order.save
      cart.contents.each do |item, quantity|
        ItemOrder.create(item_id: item.to_i, order_id: order.id, quantity: quantity, price: Item.find(item.to_i).price.to_f)
      end
      session.delete(:cart)
      redirect_to "/orders/#{order.id}"
    else
      flash.now[:error] = order.errors.full_messages.to_sentence
      render :new
    end
  end

  def show
    @order = Order.find(params[:order_id])
  end

  private

  def order_params
    params.permit(:customer_name, :customer_address, :customer_city, :customer_state, :customer_zip)
  end
end
