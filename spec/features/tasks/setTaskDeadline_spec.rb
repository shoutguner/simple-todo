require 'rails_helper'
require 'support/login_page'

feature 'Set task deadline', js: true do
  before do
    @user = FactoryGirl.create(:confirmed_user)
    FactoryGirl.create(:project)
    FactoryGirl.create(:task)
    @login_page = LoginPage.new
    @login_page.visit
  end

  scenario 'set passed deadline' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'

    page.find('#task_id_0_text').click
    page.find('#set_task_deadline_0').click

    expect(page).to have_content("Edit task deadline (deadline has been already set)")
    page.find('h1').click
    # long wait time for give chance to computers, which is slow like my computer is
    expect(page).to have_selector('tr.black', wait: 60)
  end

  scenario 'set invalid deadline' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'

    page.find('#task_id_0_text').click
    fill_in 'hour_0', with: '99'
    page.find('#set_task_deadline_0').click

    expect(page).to have_content('Invalid Date')
    expect(page).to have_content("Edit task deadline (deadline wasn't set for now)")
  end
end