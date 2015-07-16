require 'rails_helper'
require 'support/login_page'

feature 'Change task status', js: true do
  before do
    @user = FactoryGirl.create(:confirmed_user)
    FactoryGirl.create(:project)
    FactoryGirl.create(:task)
    @login_page = LoginPage.new
    @login_page.visit
  end

  scenario 'check/uncheck checkbox to change' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'
    page.find('#status_checkbox_0').click
    expect(page).to have_css('span.done-task', wait: 10)

    page.find('#status_checkbox_0').click
    expect(page).to have_no_css('span.done-task', wait: 10)

    page.find('#task_id_0_text').click
    page.find('#set_task_deadline_0').click

    expect(page).to have_content('Edit task deadline (deadline has been already set)')
    page.find('h1').click
    expect(page).to have_selector('tr.black', wait: 30)

    page.find('#status_checkbox_0').click
    expect(page).to have_no_css('tr.black', wait: 10)
  end
end