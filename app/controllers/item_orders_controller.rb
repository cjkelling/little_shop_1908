class ItemOrdersController<ApplicationController
  def destroy
    item_order = ItemOrder.find(params[:item_order_id])
    item_order.destroy
    redirect_to '/orders'
  end
end
