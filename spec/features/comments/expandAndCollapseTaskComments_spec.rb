require 'rails_helper'
require 'support/login_page'

feature 'Expand and collapse task comments', js: true do
  before do
    @user = FactoryGirl.create(:confirmed_user)
    FactoryGirl.create(:project)
    FactoryGirl.create(:task)
    FactoryGirl.create(:comment)
    @login_page = LoginPage.new
    @login_page.visit
  end

  scenario 'click to expand, see comment, click to collapse' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'

    page.find('#task_id_0_text').click
    page.find('#expand_comments_0').click

    expect(page).to have_content('Comments (click to collapse):')
    expect(page).to have_content('First comment')

    page.find('#collapse_comments_0').click

    expect(page).to have_content('Comments (click to expand)')
  end
end