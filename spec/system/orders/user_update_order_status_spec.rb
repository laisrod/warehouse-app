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
    order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                         estimated_delivery_date: 1.day.from_now, status: :pending)

    # Act
    login_as(user)
    visit root_path
    click_on 'Meus Pedidos'
    click_on order.code
    click_on 'Marcar como Entregue'

    # Assert
    expect(current_path).to eq order_path(order.id)
    expect(page).to have_content 'Pedido marcado como entregue com sucesso'
    within('dl') do
      expect(page).to have_content 'Situação do Pedido:'
      expect(page).to have_content 'Entregue'
    end
    expect(page).not_to have_button 'Marcar como Entregue'
  end
  it 'e pedido foi cancelado' do
  end
end