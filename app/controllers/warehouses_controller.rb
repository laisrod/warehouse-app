class WarehousesController < ApplicationController
  #before_action :set_warehouse, only: [:show]

  def show
      id = params[:id]
      @warehouse = Warehouse.find(id)
  end

  def new
    @warehouse = Warehouse.new
  end
    
  def create
    # Aqui dentro que nos vamos:
    # 1 - Receber dados enviados
    # 2 -Criar um novo galpão no baco de dados

   warehouse_params = params.require(:warehouse).permit(:name, :code, :description,
                                                        :cep, :area, :address, :city) #Strong Parameter

    @warehouse = Warehouse.new(warehouse_params)

    if @warehouse.save()
    redirect_to root_path, notice: 'Galpão cadastrado com sucesso.'
    else
      redirect_to root_path, notice: 'Galpão não cadastrado.'
    end
  end
end