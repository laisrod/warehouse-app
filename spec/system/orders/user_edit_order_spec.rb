require 'rails_helper'

describe 'Usuário edita seu pedido' do
  it 'e deve estar autenticado' do
    joao = User.create!(name: 'Joao', email: 'joao@email.com', password: 'password')
    other_user = User.create!(name: 'Carla', email: 'carla@email.com', password: 'password')

    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                registration_number: '4343434343434', email: 'contato@acme.com',
                                full_address: 'Avenida das Palmas, 1000', city: 'Bauru', state: 'SP')
    order = Order.create!(user: joao, warehouse: warehouse, supplier:supplier,
                                estimated_delivery_date: 1.day.from_now)    

    # Act
  visit edit_order_path(order.id)

  # Assert
   expect(current_path).to eq new_user_session_path
  end

  it 'com sucesso' do
    #Arrange
    joao = User.create!(name: 'Joao', email: 'joao@email.com', password: 'password')
    other_user = User.create!(name: 'Carla', email: 'carla@email.com', password: 'password')

    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                registration_number: '4343434343434', email: 'contato@acme.com',
                                full_address: 'Avenida das Palmas, 1000', city: 'Bauru', state: 'SP')
    Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '76767676767676',
                                full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'contato@spark.com')            
    order = Order.create!(user: joao, warehouse: warehouse, supplier:supplier,
                                estimated_delivery_date: 1.day.from_now)    

    # Act
    login_as(joao)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Editar'
    fill_in 'Data Prevista de Entrega', with: 3.days.from_now
    select 'Spark Industries Brasil LTDA', from: 'Fornecedor'
    click_on 'Gravar'

    # Assert
    expect(page).to have_content 'Pedido atualizado com sucesso'
    expect(page).to have_content 'Fornecedor:'
    expect(page).to have_content 'Spark Industries Brasil LTDA'
    expect(page).to have_content 'Data Prevista de Entrega:'
    expect(page).to have_content "#{3.days.from_now.strftime('%d/%m/%Y')}"
  end

  it 'caso seja o responsável' do
    andre = User.create!(name: 'André', email: 'andre@email.com', password: 'password')
    joao = User.create!(name: 'Joao', email: 'joao@email.com', password: 'password')
    other_user = User.create!(name: 'Carla', email: 'carla@email.com', password: 'password')

    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                registration_number: '4343434343434', email: 'contato@acme.com',
                                full_address: 'Avenida das Palmas, 1000', city: 'Bauru', state: 'SP')
    Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', registration_number: '76767676767676',
                                full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'contato@spark.com')            
    order = Order.create!(user: joao, warehouse: warehouse, supplier:supplier,
                                estimated_delivery_date: 1.day.from_now)    

    # Act
    login_as(andre)
    visit edit_order_path(order.id)

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não possui acesso a este pedido'
  end
end
