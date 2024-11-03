require 'rails_helper'

describe 'Usuário adiciona itens ao pedido' do

  it 'com sucesso' do
    #Arrange
    user = User.create!(name: 'Joao', email: 'joao@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                registration_number: '4343434343434', email: 'contato@acme.com',
                                full_address: 'Avenida das Palmas, 1000', city: 'Bauru', state: 'SP')
    order = Order.create!(user: user, warehouse: warehouse, supplier:supplier,
                                estimated_delivery_date: 1.day.from_now)  
    product_a = ProductModel.create!(name: 'Caneta BIC Azul', 
                                weight: 100, width: 100, height: 100, depth: 10,
                                supplier: supplier, sku: 'PRODUTOA')
    product_b = ProductModel.create!(name: 'Caneta BIC Vermelha', 
                                weight: 100, width: 100, height: 100, depth: 10,
                                supplier: supplier, sku: 'PRODUTOB')  

    #Act
    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Adicionar Item'

    select 'Caneta BIC Azul', from: 'Item'
    fill_in 'Quantidade', with: 5
    click_on 'Gravar'

    #Assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Item adicionado com sucesso'
    expect(page).to have_content '5 x Caneta BIC Azul'
  end

  it 'e não vê produtos de outro fornecedor' do
    user = User.create!(name: 'Joao', email: 'joao@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                description: 'Galpão destinado para cargas internacionais')
    supplier_a = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                registration_number: '4343434343434', email: 'contato@acme.com',
                                full_address: 'Avenida das Palmas, 1000', city: 'Bauru', state: 'SP')
    supplier_b = Supplier.create!(corporate_name: 'Samsung', brand_name: 'Samsung', 
                                registration_number: '1234567890123', email: 'contato@samsung.com',
                                full_address: 'Avenida das Galáxias, 1000', city: 'São Paulo', state: 'SP')

    order = Order.create!(user: user, warehouse: warehouse, supplier:supplier_a,
                                estimated_delivery_date: 1.day.from_now)  
    product_a = ProductModel.create!(name: 'Caneta BIC Azul', 
                                weight: 100, width: 100, height: 100, depth: 10,
                                supplier: supplier_a, sku: 'PRODUTOA')
    product_b = ProductModel.create!(name: 'Caneta BIC Vermelha', 
                                weight: 100, width: 100, height: 100, depth: 10,
                                supplier: supplier_b, sku: 'PRODUTOB')  
    
    #Act
    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Adicionar Item'

    #Assert
    expect(page).to have_content 'Caneta BIC Azul'
    expect(page).not_to have_content 'Caneta BIC Vermelha'
  end
end
