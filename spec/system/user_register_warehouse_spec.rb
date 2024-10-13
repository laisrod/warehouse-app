require 'rails_helper'

describe 'Usuário cadastra um galpao' do
  it 'a partir da tela inicial' do
    # Arrange


    # Act
    visit root_path
    click_on 'Cadastrar Galpão'
    
    # Assert
    expect(page).to have_field('Nome')
    expect(page).to have_field('Descrição')
    expect(page).to have_field('Código')
    expect(page).to have_field('Endereço')
    expect(page).to have_field('Cidade')
    expect(page).to have_field('CEP')
    expect(page).to have_field('Área')
  end

  it 'com sucesso' do
    # Arrange


    # Act
    visit root_path
    click_on 'Cadastrar Galpão'
    fill_in 'Nome', with: 'Rio de Janeiro'
    fill_in 'Descrição', with: 'Galpão do Rio de Janeiro'
    fill_in 'Código', with: 'SDU'
    fill_in 'Endereço', with: 'Av do Porto, 1000'
    fill_in 'Cidade', with: 'Rio de Janeiro'
    fill_in 'CEP', with: '20000-000'
    fill_in 'Área', with: '60000'
    click_on 'Enviar'

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Rio de Janeiro'
    expect(page).to have_content 'SDU'
    expect(page).to have_content '60000 m²' 
  end
end