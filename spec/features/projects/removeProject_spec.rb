require 'rails_helper'
require 'support/login_page'

feature 'Removing project', js: true do
  before do
    @user = FactoryGirl.create(:confirmed_user)
    FactoryGirl.create(:project)
    @login_page = LoginPage.new
    @login_page.visit
  end

  scenario 'click to remove' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'

    expect(page).to have_content('Complete the task for Ruby Garage')
    page.find('#remove_project_0').click
    expect(page).to have_no_content('Complete the task for Ruby Garage')
  end
end