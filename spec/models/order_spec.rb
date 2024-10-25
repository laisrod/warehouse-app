require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#valid?' do
    it 'deve ter um código' do
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', address: 'Endereço',
                                    cep: '2500-000', city: 'Rio', area: 1000,
                                    description: 'Alguma descrição')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                  registration_number: '4343434343434', email: 'contato@acme.com',
                                  full_address: 'Avenida das Palmas, 1000', city: 'Bauru', state: 'SP')
      order = Order.new(user: user, warehouse: warehouse, 
                        supplier: supplier, estimated_delivery_date: 1.day.from_now)

      order.valid?

      expect(order.code).to be_present
      expect(order).to be_valid
    end

    it 'data estimada de entrega deve ser obrigatória' do
      order = Order.new

      order.valid?

      expect(order.errors.include?(:estimated_delivery_date)).to be true
      expect(order.errors[:estimated_delivery_date]).to include("não pode ficar em branco")
    end

    it 'data estimada de entrega não deve ser passada' do
      order = Order.new(estimated_delivery_date: 1.day.ago)

      order.valid?

      expect(order.errors.include?(:estimated_delivery_date)).to be true
      expect(order.errors[:estimated_delivery_date]).to include("deve ser futura")
    end
  end

  describe 'gera um código aleatório' do
    it 'deve ter um código' do
      # Arrange
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', address: 'Endereço',
                                    cep: '2500-000', city: 'Rio', area: 1000,
                                    description: 'Alguma descrição')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                    registration_number: '4343434343434', email: 'contato@acme.com',
                                    full_address: 'Avenida das Palmas, 1000', city: 'Bauru', state: 'SP')
      order = Order.new(user: user, warehouse: warehouse, 
                        supplier: supplier, estimated_delivery_date: 2.days.from_now)

      # Act
      result = order.valid?

      unless result
        puts order.errors.full_messages
      end
    

      # Assert
      expect(result).to be true
      expect(order.errors.full_messages).to be_empty # Verifica se não há erros
    end

    it 'e o código é único' do
      # Arrang
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Santos Dumont', code: 'RIO', address: 'Endereço',
                                    cep: '2500-000', city: 'Rio', area: 1000,
                                    description: 'Alguma descrição')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                    registration_number: '4343434343434', email: 'contato@acme.com',
                                    full_address: 'Avenida das Palmas, 1000', city: 'Bauru', state: 'SP')
      first_order = Order.create!(user: user, warehouse: warehouse, 
                        supplier: supplier, estimated_delivery_date: '2022-10-01')
      second_order = Order.create!(user: user, warehouse: warehouse, 
                        supplier: supplier, estimated_delivery_date: '2022-11-15')

      # Act
      second_order.save!

      # Assert
      expect(second_order.code).not_to eq first_order.code
    end
  end
end
