require 'rails_helper'

RSpec.describe StockProduct, type: :model do
  describe 'gera um numeroo de série' do
    it 'ao criar um novo StockProduct' do
      #Arrange
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', 
                                  area: 100_000, address: 'Avenida do Aeroporto, 1000', 
                                  cep: '15000-000', description: 'Galpão para cargas internacionais')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                registration_number: '43447216000102', 
                                full_address: 'Av das Palmas, 100', city: 'Bauru', 
                                state: 'SP', email: 'contato@acme.com')
      order = Order.new(user: user, warehouse: warehouse, supplier: supplier, 
                       estimated_delivery_date: 2.days.from_now, status: :delivered)

      product = ProductModel.create!(name: 'Cadeira Gamer', weight: 5, supplier: supplier,
                                   height: 70, width: 75, depth: 80,
                                   sku: 'CGMER-XPTO-888')
      
      # Act
      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)
      
      #Assert
      expect(stock_product.serial_number.length).to eq 20
    end

    it 'e não é modificado' do
      #Arrange
      user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
      warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', 
                                  area: 100_000, address: 'Avenida do Aeroporto, 1000', 
                                  cep: '15000-000', description: 'Galpão para cargas internacionais')
      other_warehouse = Warehouse.create!(name: 'Maceió', code: 'MCZ', city: 'Maceió', 
                                  area: 50_000, address: 'Avenida Atlântica, 2000', 
                                  cep: '57050-000', description: 'Galpão de Maceió')
      supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                registration_number: '43447216000102', 
                                full_address: 'Av das Palmas, 100', city: 'Bauru', 
                                state: 'SP', email: 'contato@acme.com')
      order = Order.new(user: user, warehouse: warehouse, supplier: supplier, 
                       estimated_delivery_date: 2.days.from_now, status: :delivered)

      product = ProductModel.create!(name: 'Cadeira Gamer', weight: 5, supplier: supplier,
                                   height: 70, width: 75, depth: 80,
                                   sku: 'CGMER-XPTO-888')
      
      stock_product = StockProduct.create!(order: order, warehouse: warehouse, product_model: product)
      original_serial_number = stock_product.serial_number

      #Act
      stock_product.update!(warehouse: other_warehouse)

      #Assert
      expect(stock_product.serial_number).to eq original_serial_number
    end
  end
end
