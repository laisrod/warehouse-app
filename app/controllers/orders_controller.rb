class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_permission, only: [:show, :edit, :delivered]
  
  def index
    @orders = current_user.orders
  end

  def new
    @order = Order.new
    @warehouses = Warehouse.all
    @suppliers = Supplier.all
  end

  def create
    order_params = params.require(:order).permit(:warehouse_id, :supplier_id, :estimated_delivery_date)
    @order = Order.new(order_params)
    @order.user = current_user
    if @order.save
      redirect_to @order, notice: "Pedido registrado com sucesso."
    else
      @warehouses = Warehouse.all
      @suppliers = Supplier.all
      flash.now[:alert] = "Não foi possível registrar o pedido."
      render :new
  end
end

  def show
  end

  def search
    @orders = Order.where('code LIKE ?', "%#{params[:query]}%")
  end

  def edit
    @warehouses = Warehouse.all
    @suppliers = Supplier.all
  end

  def update
    order_params = params.require(:order).permit(:warehouse_id, :supplier_id, :estimated_delivery_date)
    @order = Order.find(params[:id])
    if @order.user != current_user
      redirect_to root_path, alert: 'Você não possui acesso a este pedido'
    else
      if @order.update(order_params)
        redirect_to @order, notice: 'Pedido atualizado com sucesso'
      else
        @warehouses = Warehouse.all
        @suppliers = Supplier.all
        flash.now[:alert] = 'Não foi possível atualizar o pedido'
        render :edit
      end
    end
  end

  def delivered
    @order.delivered!
    @order.order_items.each do |item|
      item.quantity.times do
        StockProduct.create!(order: @order, product_model: item.product_model,
                             warehouse: @order.warehouse)
      end
    end

    redirect_to @order, notice: 'Pedido marcado como entregue'
  end

  def cancel
    order = Order.find(params[:id])
    order.update(status: :canceled)
    redirect_to order
  end


  private

  def check_user_permission
    @order = Order.find(params[:id])
    if @order.user != current_user
      return redirect_to root_path, alert: 'Você não possui acesso a este pedido'
    end
  end
end
