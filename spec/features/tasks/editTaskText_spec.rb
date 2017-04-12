# this spec cannot edit task's name because nor webkit driver nor selenium not firing ng-blur event
require 'rails_helper'
require 'support/login_page'

feature 'Edit task text', js: true do
  before do
    @user = FactoryGirl.create(:confirmed_user)
    FactoryGirl.create(:project)
    FactoryGirl.create(:task)
    @login_page = LoginPage.new
    @login_page.visit
  end

  scenario 'edit and save  valid task' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'

    expect(page).to have_content('First task')

    page.find('#task_id_0_edit').click

    fill_in 'task_text_input_0', with: 'Another text'

    page.find('#task_id_0_edit').click

    expect(page).to have_content('Another text')
    #screenshot_and_save_page
    expect(page).to have_content('Fake expectation')
  end

  scenario 'edit and save invalid task with empty text' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'

    expect(page).to have_content('First task')

    page.find('#task_id_0_edit').click

    fill_in 'task_text_input_0', with: ''

    page.find('#task_id_0_edit').click

    expect(page).to have_content('Text is too short')
  end

  scenario 'edit and save invalid task with too long text' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'

    expect(page).to have_content('First task')

    page.find('#task_id_0_edit').click

    fill_in 'task_text_input_0', with: 'a'*141

    page.find('#task_id_0_edit').click

    expect(page).to have_content('Text is too long (maximum is 140 characters)')
  end
end
