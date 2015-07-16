require 'rails_helper'
require 'support/login_page'

feature 'Removing task', js: true do
  before do
    @user = FactoryGirl.create(:confirmed_user)
    FactoryGirl.create(:project)
    FactoryGirl.create(:task)
    @login_page = LoginPage.new
    @login_page.visit
  end

  scenario 'click to remove' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'

    expect(page).to have_content('First task')
    page.find('#task_id_0_delete').click
    expect(page).to have_no_content('First task')
  end
end