require 'rails_helper'

describe 'Usuário remove um galpão' do
  it 'com sucesso' do
    # Arrange - criar um galpao
    warehouse = Warehouse.create!(name: 'Cuiabá', code: 'CWB', city: 'Cuiabá', area: 10000,
                                address: 'Avenida dos Jacarés, 1000', cep: '15000-000',
                                description: 'Galpão no centro de Cuiabá')
    #Act - visitar a tela, abrir o galpão, clicar em remover
    visit root_path
    click_on 'Cuiabá'
    click_on 'Remover' 
    #Assert - garantir que o galpão foi removido - eu esepero que o galpao nao apareça
    expect(page).to have_content 'Galpão removido com sucesso'
    expect(page).not_to have_content 'Cuiabá'
    expect(page).not_to have_content 'CWB'
  end

  it 'e não consegue apagar o galpão que tem produtos armazenados' do
    # Arrange - criar um galpao
    first_warehouse = Warehouse.create!(name: 'Cuiabá', code: 'CWB', city: 'Cuiabá', area: 10000,
                                address: 'Avenida dos Jacarés, 1000', cep: '15000-000',
                                description: 'Galpão no centro de Cuiabá')

    second_warehouse = Warehouse.create!(name: 'Belo Horizonte', code: 'BHZ', city: 'Belo Horizonte', area: 20000,
                                address: 'Avenida dos Jacarés, 1000', cep: '15000-000',
                                description: 'Galpão no centro de Belo Horizonte')
    #Act - visitar a tela, abrir o galpão, clicar em remover
    visit root_path
    click_on 'Cuiabá'
    click_on 'Remover' 

    # Assert - garantir que o galpão foi removido - eu espero que o galpao nao apareça
    expect(page).to have_content 'Galpão removido com sucesso'
    expect(page).not_to have_content 'Cuiabá'
    expect(page).not_to have_content 'Belo Horizonte'
  end
end
