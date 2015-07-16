require 'rails_helper'
require 'support/login_page'

feature 'Open task details', js: true do
  before do
    @user = FactoryGirl.create(:confirmed_user)
    FactoryGirl.create(:project)
    FactoryGirl.create(:task)
    @login_page = LoginPage.new
    @login_page.visit
  end

  scenario 'open and close' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'

    expect(page).to have_content('First task', wait: 5)

    page.find('#task_id_0_text').click

    expect(page).to have_content("Edit task deadline (deadline wasn't set for now)")
    expect(page).to have_content('Comments (click to expand)')

    page.find('#task_id_0_text').click

    expect(page).to have_no_content("Edit task deadline (deadline wasn't set for now)")
    expect(page).to have_no_content('Comments (click to expand)')
  end
end