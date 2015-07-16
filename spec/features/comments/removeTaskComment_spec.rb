require 'rails_helper'
require 'support/login_page'

feature 'Remove task comment', js: true do
  before do
    @user = FactoryGirl.create(:confirmed_user)
    FactoryGirl.create(:project)
    FactoryGirl.create(:task)
    FactoryGirl.create(:comment)
    @login_page = LoginPage.new
    @login_page.visit
  end

  scenario 'click to remove' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'

    page.find('#task_id_0_text').click
    page.find('#expand_comments_0').click

    expect(page).to have_content('First comment')

    page.find('#remove_comment_btn_0', wait: 3).click

    expect(page).to have_no_content('First comment')
  end
end