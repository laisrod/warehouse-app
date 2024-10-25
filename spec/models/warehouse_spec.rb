require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'retorna falso quando o nome está vazio' do
        # Arrange
        warehouse = Warehouse.new(name: '', code: 'RIO', address: 'Avenida do Museu do Amanhã, 1000',
                                  cep: '20100-000', city: 'Rio de Janeiro', description: 'Galpão do Rio de Janeiro',
                                  area: 1000)
        # Act
        result = warehouse.valid?
        # Assert
        expect(result).to eq(false)
      end

      it 'retorna falso quando o código está vazio' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', code: '', address: 'Avenida do Museu do Amanhã, 1000',
                                  cep: '20100-000', city: 'Rio de Janeiro', description: 'Galpão do Rio de Janeiro',
                                  area: 1000)
        # Act
        result = warehouse.valid?
        # Assert
        expect(result).to eq(false)
      end

      it 'retorna falso quando o endereço está vazio' do
        # Arrange
        warehouse = Warehouse.new(name: 'Rio', code: 'RIO', address: '', cep: '20100-000',
                                  city: 'Rio de Janeiro', description: 'Galpão do Rio de Janeiro',
                                  area: 1000)
        # Act
        result = warehouse.valid?
        # Assert
        expect(result).to eq(false)
      end

      it 'retorna falso quando o código já está em uso' do
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


  describe '#full_description' do
  it 'exibe o nome fantasia e a razão social' do
    # Arrange
    w = Warehouse.new(name: 'Galpão Cuiabá', code: 'CBA')

    # Act
    result = w.full_description()

    # Assert
    expect(result).to eq('CBA - Galpão Cuiabá')
  end
  end

end 