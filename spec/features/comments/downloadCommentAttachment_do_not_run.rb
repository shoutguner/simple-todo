require 'rails_helper'
require 'support/login_page'

feature 'Download comment attachment', js: true do
  before do
    @user = FactoryGirl.create(:confirmed_user)
    FactoryGirl.create(:project)
    FactoryGirl.create(:task)
    @login_page = LoginPage.new
    @login_page.visit
  end

  scenario 'click to start download' do
    @login_page.sign_in(@user.email, @user.password)
    visit '#/todo'

    page.find('#task_id_0_text').click
    page.find('#expand_comments_0').click

    @file = File.expand_path(File.dirname(__FILE__) + '/IMG_20140902_130119.jpg')

    attach_file('comment_file_input_0', @file, visible: false, wait: 5)
    page.find('#save_comment_btn_0').click

    expect(page).to have_content('IMG_20140902_130119.jpg', wait: 60)
    expect(page).to have_no_content('Text is too short')

    click_link('IMG_20140902_130119.jpg')
    # there is no way to test file download with selenium
  end
end