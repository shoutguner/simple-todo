require 'rails_helper'
require 'support/login_page'

feature 'Edit project name', js: true do
  before do
    @user = FactoryGirl.create(:confirmed_user)
    FactoryGirl.create(:project)
    @login_page = LoginPage.new
    @login_page.visit
  end

  scenario 'edit and save valid project' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'

    expect(page).to have_content('Complete the task for Ruby Garage')

    page.find('#edit_project_0').click

    fill_in 'project_name_input_0', with: 'Another name'

    page.find('h1').click

    expect(page).to have_content('Another name')
  end

  scenario 'edit and save invalid project with empty name' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'

    expect(page).to have_content('Complete the task for Ruby Garage')

    page.find('#edit_project_0').click

    fill_in 'project_name_input_0', with: ''

    page.find('h1').click

    expect(page).to have_content("Name can't be blank")
  end

  scenario 'edit and save invalid project with too long name' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'

    expect(page).to have_content('Complete the task for Ruby Garage')

    page.find('#edit_project_0').click

    # page.execute_script("$('#project_name_input_0').focus()")

    fill_in 'project_name_input_0', with: 'a'*51

    page.find('h1').click

    expect(page).to have_content('Name is too long (maximum is 50 characters)')
  end
end