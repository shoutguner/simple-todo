require 'rails_helper'
require 'support/login_page'

feature 'Add new task', js: true do
  before do
    @user = FactoryGirl.create(:confirmed_user)
    FactoryGirl.create(:project)
    FactoryGirl.create(:task)
    @login_page = LoginPage.new
    @login_page.visit
  end

  scenario 'adding valid task' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'
    fill_in 'new_task_text_input_0', with: 'Added task text'
    page.first('#addTaskButton_0').click

    expect(page).to have_content('Added task text')
    expect(page).to have_no_content('Text is too short')
    expect(page.find('#new_task_text_input_0')).to have_text ''
  end

  scenario 'adding invalid task with empty text' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'
    fill_in 'new_task_text_input_0', with: ''
    page.first('#addTaskButton_0').click

    expect(page).to have_content('Text is too short')
  end

  scenario 'adding invalid task with too long text' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'
    fill_in 'new_task_text_input_0', with: 'a'*141
    page.first('#addTaskButton_0').click

    expect(page).to have_content('Text is too long (maximum is 140 characters)')
  end
end