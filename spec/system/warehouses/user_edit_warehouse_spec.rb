require 'rails_helper'

describe 'Usuário edita um galpão' do
  it 'a partir da página de detalhes' do
    # Arrange - criar um galpão no banco de dados
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100000,
                                address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                description: 'Galpão destinado para cargas internacionais')
    
    # Act - abrir o app, visitar o galpão, clicar em "Editar", trocar algo no formulário, sunmeter
    visit root_path
    click_on 'Aeroporto SP'
    click_on 'Editar'
    

    # Assert - garantir que o formulário aparece
    expect(page).to have_content 'Editar Galpão'
    expect(page).to have_field('Nome', with: 'Aeroporto SP')
    expect(page).to have_field('Descrição', with: 'Galpão destinado para cargas internacionais')
    expect(page).to have_field('Código', with: 'GRU')
    expect(page).to have_field('Endereço', with: 'Avenida do Aeroporto, 1000')
    expect(page).to have_field('Cidade', with: 'Guarulhos')
    expect(page).to have_field('CEP', with: '15000-000')
    expect(page).to have_field('Área', with: 100000)
  end

  it 'a partir da página de detalhes' do
    # Arrange - criar um galpão no banco de dados
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100000,
                                address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                description: 'Galpão destinado para cargas internacionais')
    
    # Act - abrir o app, visitar o galpão, clicar em "Editar", trocar algo no formulário, sunmeter
    visit root_path
    click_on 'Aeroporto SP'
    click_on 'Editar'
    fill_in 'Nome', with: "Galpão Internacional"
    fill_in 'Descrição', with: "Galpão destinado para cargas internacionais"
    fill_in 'Código', with: "GIG"
    fill_in 'Endereço', with: "Avenida dos Galpões, 1000"
    fill_in 'Cidade', with: "São Paulo"
    fill_in 'CEP', with: "15000-000"
    fill_in 'Área', with: 200000
    click_on 'Enviar'

    # Assert - garantir que o formulário aparece
    expect(page).to have_content 'Nome: Galpão Internacional'
    expect(page).to have_content 'Galpão destinado para cargas internacionais'
    expect(page).to have_content 'Endereço: Avenida dos Galpões, 1000'
    expect(page).to have_content 'Área: 200000'
    expect(page).to have_content 'Cidade: São Paulo'
    expect(page).to have_content 'CEP: 15000-000'
    expect(page).to have_content 'Galpão atualizado com sucesso'
  end

  it 'e mantém os campos obrigatórios' do
    # Arrange
    warehouse = Warehouse.create!(name: 'Aeroporto SP', code: 'GRU', city: 'Guarulhos', area: 100000,
                                address: 'Avenida do Aeroporto, 1000', cep: '15000-000',
                                description: 'Galpão destinado para cargas internacionais')
    visit root_path
    click_on 'Aeroporto SP'
    click_on 'Editar'
    fill_in 'Nome', with: ''
    fill_in 'Área', with: ''
    fill_in 'Endereço', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'CEP', with: ''
    click_on 'Enviar'

    # Assert
    expect(page).to have_content 'Não foi possivel atualizar o galpão.'
  end
end
