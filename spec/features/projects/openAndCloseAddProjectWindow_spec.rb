require 'rails_helper'
require 'support/login_page'

feature 'Open modal window for adding new project', js: true do
  before do
    @user = FactoryGirl.create(:confirmed_user)
    FactoryGirl.create(:project)
    FactoryGirl.create(:task)
    @login_page = LoginPage.new
    @login_page.visit
  end

  scenario 'click to open' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'
    page.find('#open_add_project_window').click

    expect(page).to have_content('Add new task list')

    page.find('#add_project_window_cancel').click

    expect(page).to have_no_content('Add new task list')
  end
end