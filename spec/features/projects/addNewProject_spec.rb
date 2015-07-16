require 'rails_helper'
require 'support/login_page'

feature 'Adding new project in modal window', js: true do
  before do
    @user = FactoryGirl.create(:confirmed_user)
    @login_page = LoginPage.new
    @login_page.visit
  end

  scenario 'click to open and click to add valid project' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'
    page.find('#open_add_project_window').click
    fill_in 'newProjectName', with: 'New project name'
    page.find('#add_project_window_add').click

    expect(page).to have_content('New project name', wait: 5)
  end

  scenario 'click to open and click to add project with empty name' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'
    page.find('#open_add_project_window').click
    fill_in 'newProjectName', with: ''
    page.find('#add_project_window_add').click

    expect(page).to have_content("Name can't be blank")
  end

  scenario 'click to open and click to add project with too long name' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'
    page.find('#open_add_project_window').click
    fill_in 'newProjectName', with: 'a'*51
    page.find('#add_project_window_add').click

    expect(page).to have_content('Name is too long (maximum is 50 characters)')
  end
end