require 'rails_helper'

describe 'Usuário cadastra um modelo de produto' do 
  it 'com sucesso' do
    # Arrange
    user = User.create!(name: "Joao", email: 'joao@gmail.com', password: 'password')
    supplier = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Eletronics LTDA',
                                registration_number: '12345678000123', full_address: 'Av Nacoes Unidas, 1000',
                                city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')

    other_supplier = Supplier.create!(brand_name: 'LG', corporate_name: 'LG do Brasil LTDA',
                                registration_number: '34356608000149', full_address: 'Av Ibirapuera, 1000',
                                city: 'São Paulo', state: 'SP', email: 'contato@lg.com.br')
  # Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Produtos'
    click_on 'Cadastrar Novo'
    fill_in 'Nome', with: 'TV 40 polegadas'
    fill_in 'Peso', with: 10_000
    fill_in 'Altura', with: 60
    fill_in 'Largura', with: 90
    fill_in 'Profundidade', with: 10
    fill_in 'SKU', with: 'TV40-SAMS-XPTO'
    select 'Samsung', from: 'Fornecedor'
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Modelo de produto cadastrado com sucesso'
    expect(page).to have_content 'TV 40 polegadas'
    expect(page).to have_text 'Samsung'
    expect(page).to have_content 'TV40-SAMS-XPTO'
    expect(page).to have_content '60cm x 90cm x 10cm'
    expect(page).to have_content '10000g'
  end

  it 'deve preencher todos os campos' do 
    #Arrange
    user = User.create!(name: "Joao", email: 'joao@gmail.com', password: 'password')
    supplier = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Eletronics LTDA',
                            registration_number: '12345678000123', 
                            full_address: 'Av Nacoes Unidas, 1000',
                            city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')

    pm = ProductModel.new(name:'', weight: 8000, width: 70, height: 45, depth: 10,
                          sku: 'TV32-SAMSU-XPT090', supplier: supplier)
    #Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Produtos'
    click_on 'Cadastrar Novo'
    fill_in 'Nome', with: ''
    fill_in 'SKU', with: ''
    click_on 'Enviar'

    expect(page). to have_content 'Não foi possivel cadastrar o modelo de produto.'
    #Assert
  end
end