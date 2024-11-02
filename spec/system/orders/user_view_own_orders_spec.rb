require 'rails_helper'

describe 'Usuário vê seus próprios pedidos' do
  it 'e deve estar autenticado' do
    # Arrange

    # Act
    visit root_path
    click_on 'Meus Pedidos'

    # Assert
    expect(current_path).to eq new_user_session_path
  end

  it 'e não vê outros pedidos' do
    # Arrange
    joao = User.create!(name: 'Joao', email: 'joao@email.com', password: 'password')
    carla = User.create!(name: 'Carla', email: 'carla@email.com', password: 'password')

    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                              registration_number: '4343434343434', email: 'contato@acme.com',
                              full_address: 'Avenida das Palmas, 1000', city: 'Bauru', state: 'SP')
    first_order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier,
                              estimated_delivery_date: 1.day.from_now, status: 'pending')
    second_order = Order.create!(user: carla, warehouse: warehouse, supplier: supplier,
                              estimated_delivery_date: 1.day.from_now, status: 'delivered')
    third_order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier,
                              estimated_delivery_date: 1.week.from_now, status: 'canceled')
                               
    # Act
    login_as(joao)
    visit root_path
    click_on 'Meus Pedidos'
    
    # Assert
    expect(page).to have_content first_order.code
    expect(page).to have_content 'Pendente'
    expect(page).not_to have_content second_order.code
    expect(page).not_to have_content 'Entregue'
    expect(page).to have_content third_order.code
    expect(page).to have_content 'Cancelado'
  end

  it 'e visita um pedido' do
    #Arrange
    joao = User.create!(name: 'Joao', email: 'joao@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                              registration_number: '4343434343434', email: 'contato@acme.com',
                              full_address: 'Avenida das Palmas, 1000', city: 'Bauru', state: 'SP')
    first_order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier,
                              estimated_delivery_date: 1.day.from_now, status: 'pending')

    #Act
    login_as(joao)
    visit root_path
    click_on 'Meus Pedidos'
    click_on first_order.code

    #Assert
    expect(page).to have_content 'Detalhes do Pedido'
    expect(page).to have_content first_order.code
    
    within('dl') do
      expect(page).to have_content 'Galpão Destino'
      expect(page).to have_content 'GRU'
      expect(page).to have_content 'Aeroporto SP'
      expect(page).to have_content 'Fornecedor'
      expect(page).to have_content 'ACME LTDA'
    end
    
    formatted_date = I18n.localize(1.day.from_now.to_date)
    expect(page).to have_content formatted_date
  end

  it 'e vê itens do pedido' do
    #Arrange
    user = User.create!(name: 'Joao', email: 'joao@email.com', password: 'password')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                              registration_number: '4343434343434', email: 'contato@acme.com',
                              full_address: 'Avenida das Palmas, 1000', city: 'Bauru', state: 'SP')
    
    product_a = ProductModel.create!(name: 'Caneta BIC Azul', 
                                     weight: 100, width: 100, height: 100, depth: 10,
                                     supplier: supplier, sku: 'PRODUTOA')
    product_b = ProductModel.create!(name: 'Caneta BIC Vermelha', 
                                     weight: 100, width: 100, height: 100, depth: 10,
                                     supplier: supplier, sku: 'PRODUTOB')

    # Criamos o warehouse
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', 
                                  area: 100_000, address: 'Avenida do Aeroporto, 1000', 
                                  cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')

    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier,
                              estimated_delivery_date: 1.day.from_now, status: 'pending')

    OrderItem.create!(order: order, product_model: product_a, quantity: 5)
    OrderItem.create!(order: order, product_model: product_b, quantity: 10)

    #Act
    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code

    #Assert
    expect(page).to have_content 'Detalhes do Pedido'
    expect(page).to have_content order.code
    expect(page).to have_content 'Itens do Pedido'
    expect(page).to have_content '5 x Caneta BIC Azul'
    expect(page).to have_content '10 x Caneta BIC Vermelha'
  end
end 