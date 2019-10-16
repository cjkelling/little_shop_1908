class OrdersController < ApplicationController
  def new; end

  def index
    @orders = Order.all
  end

  def create
    order = Order.create(order_params)
    order.order_number = ('%010d' % rand(10**10))
    if order.save
      cart.contents.each do |item, quantity|
        ItemOrder.create(item_id: item.to_i, order_id: order.id, quantity: quantity, price: Item.find(item.to_i).price.to_f)
      end
      session.delete(:cart)
      flash[:success] = "Your order number is #{order.order_number}"
      redirect_to "/orders/#{order.id}"
    else
      flash.now[:error] = order.errors.full_messages.to_sentence
      render :new
    end
  end

  def show
    @order = Order.find(params[:order_id])
  end

  def verified_order
    order = Order.search(params[:search])

    if order
      @order = order
    else
      flash[:error] = 'Order not found'
      redirect_to '/items'
    end
  end

  def destroy
    order = Order.find(params[:order_id])
    order.destroy
    redirect_to '/items'
  end

  private

  def order_params
    params.permit(:customer_name, :customer_address, :customer_city, :customer_state, :customer_zip, :search)
  end
end
