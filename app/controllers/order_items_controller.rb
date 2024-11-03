class OrderItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order

  def new
    @order_item = OrderItem.new
    @product_models = @order.supplier.product_models
  end

  def create
    @order_item = OrderItem.new(order_item_params)
    @order_item.order = @order

    Rails.logger.debug "Params recebidos: #{order_item_params.inspect}"
    Rails.logger.debug "Order Item antes de salvar: #{@order_item.inspect}"

    if @order_item.save
      Rails.logger.debug "Order Item depois de salvar: #{@order_item.inspect}"
      Rails.logger.debug "Order Items do pedido: #{@order.order_items.reload.inspect}"
      redirect_to @order, notice: 'Item adicionado com sucesso'
    else
      Rails.logger.debug "Erros ao salvar: #{@order_item.errors.full_messages}"
      @product_models = @order.supplier.product_models
      flash.now[:alert] = 'Não foi possível adicionar o item'
      render :new
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def order_item_params
    params.require(:order_item).permit(:product_model_id, :quantity)
  end
end 