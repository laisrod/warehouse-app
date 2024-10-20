require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'returns false when name is empty' do
        # Arrange
        warehouse = Warehouse.new(name: '', code: 'RIO', address: 'Avenida do Museu do Amanhã, 1000',
                                  cep: '20100-000', city: 'Rio de Janeiro', description: 'Galpão do Rio de Janeiro',
                                  area: 1000)
        # Act
        result = warehouse.valid?
        # Assert
        expect(result).to eq(false)
      end

      it 'returns false when code is empty' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', code: '', address: 'Avenida do Museu do Amanhã, 1000',
                                  cep: '20100-000', city: 'Rio de Janeiro', description: 'Galpão do Rio de Janeiro',
                                  area: 1000)
        # Act
        result = warehouse.valid?
        # Assert
        expect(result).to eq(false)
      end

      it 'returns false when address is empty' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: '', cep: '20100-000',
                                  city: 'Rio de Janeiro', description: 'Galpão do Rio de Janeiro',
                                  area: 1000)
        # Act
        result = warehouse.valid?
        # Assert
        expect(result).to eq(false)
      end

      it 'returns false when code is already in use' do
        # Arrange
        first_warehouse = Warehouse.create(name: 'Rio', code: 'RIO', address: 'Avenida do Museu do Amanhã, 1000',
                                           cep: '20100-000', city: 'Rio de Janeiro', description: 'Galpão do Rio de Janeiro',
                                           area: 1000)
        second_warehouse = Warehouse.new(name: 'Niteroi', code: 'RIO', address: 'Avenida do Museu do Amanhã, 1000',
                                         cep: '20100-000', city: 'Rio de Janeiro', description: 'Galpão do Rio de Janeiro',
                                         area: 1000)
        # Act
        result = second_warehouse.valid?
        # Assert
        expect(result).to eq(false)
      end
    end
  end
end
