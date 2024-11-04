require 'rails_helper'

describe 'Usuário novo status de pedido' do

  it 'e pedido foi entregue' do
    
    # Arrange
    user = User.create!(name: 'João da Silva', email: 'joao@example.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', 
                                area: 100_000, address: 'Avenida do Aeroporto, 1000', 
                                cep: '15000-000', description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                              registration_number: '247474747474747', 
                              full_address: 'Av das Palmas, 100', city: 'Bauru', 
                              state: 'SP', email: 'contato@acme.com')
    
    product_model = ProductModel.create!(name: 'Caneta BIC Azul', weight: 100, width: 100, 
                                       height: 100, depth: 10, supplier: supplier,
                                       sku: 'CANETA-BIC-001')
    
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                         estimated_delivery_date: 1.day.from_now, status: :pending)

    OrderItem.create!(product_model: product_model, quantity: 10, order: order)
    
    # Act
    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Marcar como Entregue'

    # Assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Entregue'
    expect(page).not_to have_button 'Marcar como Entregue'
    expect(page).not_to have_button 'Marcar como Cancelado'

    expect(StockProduct.count).to eq 10
    estoque = StockProduct.where(product_model: product_model, warehouse: warehouse).count
    expect(estoque).to eq 10
  end

  it 'e pedido foi cancelado' do
    # Arrange
    user = User.create!(name: 'João da Silva', email: 'joao@example.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', 
                                area: 100_000, address: 'Avenida do Aeroporto, 1000', 
                                cep: '15000-000', description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                              registration_number: '247474747474747', 
                              full_address: 'Av das Palmas, 100', city: 'Bauru', 
                              state: 'SP', email: 'contato@acme.com')
    
    product = ProductModel.create!(name: 'Caneta BIC Azul', weight: 100, width: 100, 
                                 height: 100, depth: 10, supplier: supplier,
                                 sku: 'CANETA-BIC-001')
    
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                         estimated_delivery_date: 1.day.from_now, status: :pending)

    OrderItem.create!(product_model: product, quantity: 5, order: order)
    
    # Act
    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Cancelar Pedido'

    # Assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Situação do Pedido:'
    expect(page).to have_content 'Cancelado'
    expect(page).not_to have_button 'Marcar como Entregue'
    expect(page).not_to have_button 'Cancelar Pedido'
  end

end