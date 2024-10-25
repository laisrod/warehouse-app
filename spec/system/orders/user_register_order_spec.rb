require 'rails_helper'

describe 'Usuário cadastra um pedido' do

  it 'e deve estar autenticado' do

    # Arrange

    # Act
    visit root_path
    click_on 'Registrar Pedido'

    # Assert
    expect(current_path).to eq new_user_session_path


  end



  it 'com sucesso' do
    # Arrange
    user = User.create!(name: 'Sergio', email: 'sergio@email.com', password: '12345678')
    Warehouse.create!(name: 'Galpão Maceio', code: 'MCD', city: 'Maceio', area: 50_000,
                                  address: 'Avenida do Aeroporto, 1000', cep: '57050-000',
                                  description: 'Galpão de Maceio')
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100_000,
                                  address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                  description: 'Galpão destinado para cargas internacionais')
    
    Supplier.create!(corporate_name: 'Spark Industries Brasil LTDA', brand_name: 'Spark', 
                                  registration_number: '76767676767676', email: 'contato@spark.com',
                                  full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI')              
    supplier = Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', 
                                registration_number: '4343434343434', email: 'contato@acme.com',
                                full_address: 'Avenida das Palmas, 1000', city: 'Bauru', state: 'SP')
    
    allow(SecureRandom).to receive(:alphanumeric).and_return('ABC12345')

    # Act
    login_as(user)
    visit root_path
    click_on 'Registrar Pedido'
    select 'GRU - Aeroporto SP', from: 'Galpão Destino'
    select supplier.corporate_name, from: 'Fornecedor'
    fill_in 'Data Prevista', with: 3.days.from_now.strftime('%d/%m/%Y')
    click_on 'Gravar'

    # Assert
    expect(page).to have_content 'Pedido registrado com sucesso'
    expect(page).to have_content 'Pedido ABC12345'
    expect(page).to have_content 'Galpão Destino: GRU - Aeroporto SP'
    expect(page).to have_content 'Fornecedor: ACME LTDA'
    expect(page).to have_content 'Usuário Responsavel: Sergio - sergio@email.com'
    expect(page).to have_content 'Data Prevista de Entrega: 20/12/2022'
    expect(page).not_to have_content 'Galpão Maceio'
    expect(page).not_to have_content 'Spark Industries Brasil LTDA'
  end
end
