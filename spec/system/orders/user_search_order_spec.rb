require 'rails_helper'

describe 'Usuário busca por um pedido' do

    it 'a partir do menu' do
      # Arrange
      user = User.create!(name: 'Joao', email: 'joao@email.com', password: 'password')
      # Act
      login_as(user)
      visit root_path
        
      # Assert
      within('header nav') do
        expect(page).to have_field('Buscar Pedido')
        expect(page).to have_button('Buscar')
      end
    end

    it 'e deve estar autenticado' do
      # Arrange
      # Act
      visit root_path
      # Assert
      within('header nav') do
        expect(page).not_to have_field('Buscar Pedido')
        expect(page).not_to have_button('Buscar')
      end
    end

    it 'e encontra um pedido' do
      # Arrange
      user = User.create!(name: 'Joao', email: 'joao@email.com', password: 'password')
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                  registration_number: '4343434343434', email: 'contato@acme.com',
                                  full_address: 'Avenida das Palmas, 1000', city: 'Bauru', state: 'SP')
      order = Order.create!(user: user, warehouse: warehouse, supplier:supplier,
                    estimated_delivery_date: 1.day.from_now)
      # Act
      login_as(user)
      visit root_path
      fill_in 'Buscar Pedido', with: order.code
      click_on 'Buscar'

      # Assert
      expect(page).to have_content "Resultados da Busca por: #{order.code}"
      expect(page).to have_content("1 pedido(s) encontrado(s)")
      expect(page).to have_content "#{order.code}"
      expect(page).to have_content "Aeroporto SP"
      expect(page).to have_content "ACME LTDA"
    end

    it 'e encontra múltiplos pedidos' do
      # Arrange
      user = User.create!(name: 'Joao', email: 'joao@email.com', password: 'password')
      first_warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
      second_warehouse = Warehouse.create!(name: 'Aeroporto Rio', code: 'SDU', city: 'Rio de Janeiro', area: 100_000,
                                  address: 'Avenida do Porto, 80', cep: '25000-000',
                                  description: 'Galpão destinado para cargas internacionais')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                  registration_number: '4343434343434', email: 'contato@acme.com',
                                  full_address: 'Avenida das Palmas, 1000', city: 'Bauru', state: 'SP')

      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return("GRU12345")
      first_order = Order.create!(user: user, warehouse: first_warehouse, supplier:supplier,
                    estimated_delivery_date: 1.day.from_now)
      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return("GRU98765")
      second_order = Order.create!(user: user, warehouse: first_warehouse, supplier:supplier,
                    estimated_delivery_date: 1.day.from_now)
      
      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return("SDU00000")
      third_order = Order.create!(user: user, warehouse: second_warehouse, supplier:supplier,
                    estimated_delivery_date: 1.day.from_now)
      # Act
      login_as(user)
      visit root_path
      fill_in 'Buscar Pedido', with: 'GRU'
      click_on 'Buscar'
      #Assert
      expect(page).to have_content('GRU12345')
      expect(page).to have_content('GRU98765')
      expect(page).to have_content('GRU - Aeroporto SP')

      expect(page).not_to have_content('SDU00000')
      expect(page).not_to have_content('SDU - Aeroporto Rio')


    end

end