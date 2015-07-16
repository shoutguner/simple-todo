require 'rails_helper'
require 'support/login_page'
require 'support/registration_page'

feature 'Registration', js: true do

  before do
    @registration_page = RegistrationPage.new
    @registration_page.visit
  end

  feature 'with valid inputs' do
    let(:password) { Faker::Internet.password }
    let(:email) { Faker::Internet.email }
    before { @registration_page.complete_form(email: email, password: password, password_confirmation: password) }

    scenario 'account creation' do
      find('a', text: 'Sign out').click
      login_page = LoginPage.new
      # we must already be on login page because of redirect, if this change - uncomment line below
      # login_page.visit
      login_page.sign_in(email, password)
      expect(page).to have_content('Sign out')
    end

    scenario 'sign-in upon account creation' do
      expect(page).to have_content('Sign out')
    end
  end

  scenario 'with invalid inputs' do
    @registration_page.complete_form(email: 'email@email', password: 'a', password_confirmation: 'b')

    expect(page).to have_content("Password confirmation doesn't match Password")
    expect(page).to have_content('Password is too short')
    expect(page).to have_content('Email is not an email')
  end

  scenario 'with too long password' do
    @registration_page.complete_form(email: 'email@email.com', password: 'a'*73, password_confirmation: 'a'*73)
    expect(page).to have_content('Password is too long (maximum is 72 characters)')
  end
end