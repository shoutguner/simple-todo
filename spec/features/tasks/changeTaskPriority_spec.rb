require 'rails_helper'
require 'support/login_page'

feature 'Change task priority', js: true do
  before do
    @user = FactoryGirl.create(:confirmed_user)
    FactoryGirl.create(:project)
    FactoryGirl.create(:task)
    @login_page = LoginPage.new
    @login_page.visit
  end

  scenario 'click to change' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'
    page.find('#task_id_0_priority_0_up').click
    expect(page).to have_selector('#task_id_0_priority_0_up')

    fill_in 'new_task_text_input_0', with: "Second task text"
    page.find('#addTaskButton_0').click

    # long wait time for give chance to computers, which is slow like my computer is
    expect(page).to have_selector('#task_id_1_priority_1_up', wait: 30)

    page.find('#task_id_0_priority_0_up').click

    expect(page).to have_selector('#task_id_1_priority_0_up', wait: 30)
    expect(page).to have_selector('#task_id_0_priority_1_down', wait: 30)

    page.find('#task_id_1_priority_0_down').click

    expect(page).to have_selector('#task_id_1_priority_0_up', wait: 30)
    expect(page).to have_selector('#task_id_0_priority_1_up', wait: 30)
  end
end