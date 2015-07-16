require 'rails_helper'
require 'support/login_page'

feature 'Authentication', js: true do
  before do
    @user = FactoryGirl.create(:confirmed_user)
    @login_page = LoginPage.new
    @login_page.visit
  end

  feature 'login' do
    scenario 'with valid inputs' do
      @login_page.sign_in(@user.email, @user.password)
      expect(page).to have_content('Sign out')
    end

    scenario 'with invalid credentials' do
      @login_page.sign_in('invalid@lol.com', 'not the actual password')
      expect(page).to have_content('Invalid login credentials. Please try again.')
    end

    scenario 'redirect after login' do
      @login_page.sign_in(@user.email, @user.password)
      expect(page).to have_content('Add TODO List')
    end
  end

  feature 'page access' do
    scenario 'visiting todo page when signed in' do
      @login_page.sign_in(@user.email, @user.password)
      visit '#/todo'
      expect(page).to have_content('Add TODO List')
      expect(page).to have_content('Sign out')
    end

    scenario 'visiting todo page when not signed in' do
      visit '#/todo'
      expect(page).not_to have_content('Add TODO List')
    end
  end
end