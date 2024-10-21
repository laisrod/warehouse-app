require 'rails_helper'

RSpec.describe 'Usuário cadastra um modelo de produto' do
  let(:user) { User.create(email: 'usuario@exemplo.com', password: 'senha123', name: 'Nome do Usuário') }

  before do
    sign_in user
  end

  it 'com sucesso' do
    # Seu código de teste aqui
    # Por exemplo:
    visit new_product_model_path
    # Preencha os campos necessários
    # Clique no botão de submissão
    # Faça as asserções necessárias
  end

  it 'deve preencher todos os campos' do 
    #Arrange
    supplier = Supplier.create!(brand_name: 'Samsung', corporate_name: 'Samsung Eletronics LTDA',
                            registration_number: '12345678000123', 
                            full_address: 'Av Nacoes Unidas, 1000',
                            city: 'São Paulo', state: 'SP', email: 'sac@samsung.com.br')

    pm = ProductModel.new(name:'', weight: 8000, width: 70, height: 45, depth: 10,
                          sku: 'TV32-SAMSU-XPT090', supplier: supplier)
    #Act
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
