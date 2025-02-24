require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'gera um codigo aleaório' do
    it 'ao criar um novo pedido' do
      # Arrange
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', 
                                  area: 100_000, address: 'Avenida do Aeroporto, 1000', 
                                  cep: '15000-000', description: 'Galpão para cargas internacionais')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                registration_number: '43447216000102', 
                                full_address: 'Av das Palmas, 100', city: 'Bauru', 
                                state: 'SP', email: 'contato@acme.com')
      order = Order.new(user: user, warehouse: warehouse, supplier: supplier, 
                       estimated_delivery_date: 2.days.from_now)
      # Act
      order.save!
      result = order.code
      
      # Assert
      #empty?
      expect(result).not_to be_empty
      expect(result.length).to eq 8
    end

    it 'deve ter um código' do
      # Arrange
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', address: 'Endereço',
                                    cep: '2500-000', city: 'Rio', area: 1000,
                                    description: 'Alguma descrição')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                 registration_number: '4343434343434', email: 'contato@acme.com',
                                      full_address: 'Avenida das Palmas, 1000', city: 'Bauru', state: 'SP')
      order = Order.new(user: user, warehouse: warehouse,  code: 'ABC', 
                        supplier: supplier, estimated_delivery_date: 1.day.from_now)
  
      result = order.save!
  
      # Assert
      expect(result).to be true
      expect(order.errors.full_messages).to be_empty
    end
  
    it 'e o código é único' do
      # Arrange
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', address: 'Endereço',
                                    cep: '2500-000', city: 'Rio', area: 1000,
                                    description: 'Alguma descrição')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                    registration_number: '4343434343434', email: 'contato@acme.com',
                                    full_address: 'Avenida das Palmas, 1000', city: 'Bauru', state: 'SP')
      first_order = Order.create!(user: user, warehouse: warehouse,  code: 'ABC',
                                  supplier: supplier, estimated_delivery_date: 2.days.from_now)
      second_order = Order.create!(user: user, warehouse: warehouse,  code: 'ABC',
                                     supplier: supplier, estimated_delivery_date: 3.days.from_now)
  
      # Assert
      expect(second_order.code).not_to eq first_order.code
    end

    it 'e não deve ser modificado' do
        # Arrange
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', address: 'Endereço',
                                    cep: '2500-000', city: 'Rio', area: 1000,
                                    description: 'Alguma descrição')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                    registration_number: '4343434343434', email: 'contato@acme.com',
                                    full_address: 'Avenida das Palmas, 1000', city: 'Bauru', state: 'SP')
      order = Order.create!(user: user, warehouse: warehouse, supplier: supplier, 
                            estimated_delivery_date: 1.day.from_now)
      original_code = order.code

      # Act
      order.update!(estimated_delivery_date: 1.month.from_now)
      # Assert
      expect(order.code).to eq original_code
    end
  end


  describe '#valid?' do
    it 'deve ter um código' do
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', address: 'Endereço',
                                    cep: '2500-000', city: 'Rio', area: 1000,
                                    description: 'Alguma descrição')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                  registration_number: '4343434343434', email: 'contato@acme.com',
                                  full_address: 'Avenida das Palmas, 1000', city: 'Bauru', state: 'SP')
      order = Order.new(user: user, warehouse: warehouse, code: 'ABC',
                        supplier: supplier, estimated_delivery_date: 1.day.from_now)

      # Act
      result = order.valid?
      # Assert
      expect(result).to be true
    end

    it 'data estimada de entrega deve ser obrigatória' do
      # Arrange
     order = Order.new(estimated_delivery_date: '')
      # Act
      order.valid?
      result = order.errors.include?(:estimated_delivery_date)
      # Assert
      expect(result).to be true
    end 

    it 'data estimada de entrega não deve ser passada' do
      # Arrange
      order = Order.new(estimated_delivery_date: 1.day.ago)
      # Act
      order.valid?
      # Assert
      expect(order.errors.include?(:estimated_delivery_date)).to be true
      expect(order.errors.full_messages_for(:estimated_delivery_date)).to include("Data Prevista de Entrega  deve ser futura.")
    end

    it 'data estimada de entrega deve ser igual ou maior que amanhã' do
      # Arrange
      order = Order.new(estimated_delivery_date: 1.day.from_now)
      # Act
      order.valid?
      # Assert
      expect(order.errors.include?(:estimated_delivery_date)).to be false
    end
  end
end