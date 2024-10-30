require 'rails_helper'

describe 'Usuário edita seu pedido' do
  it 'e não é o dono' do
    # Arrange
    andre = User.create!(name: 'André', email: 'andre@email.com', password: 'password')
    joao = User.create!(name: 'Joao', email: 'joao@email.com', password: 'password')
    other_user = User.create!(name: 'Carla', email: 'carla@email.com', password: 'password')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                description: 'Galpão destinado para cargas internacionais')
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '4343434343434',
                                email: 'contato@acme.com', full_address: 'Avenida das Palmas, 1000', city: 'Bauru', state: 'SP')
    order = Order.create!(user: joao, warehouse: warehouse, supplier: supplier, estimated_delivery_date: 1.day.from_now)

    # Act
    login_as(andre)
    patch order_path(order.id), params: { order: { warehouse_id: 2, supplier_id: 2, estimated_delivery_date: 3.days.from_now } }

    # Assert
    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq 'Você não possui acesso a este pedido'
  end
end
