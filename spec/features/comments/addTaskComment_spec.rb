require 'rails_helper'
require 'support/login_page'

# feature 'Add task comment', js: true do
#   before do
#     @user = FactoryGirl.create(:confirmed_user)
#     FactoryGirl.create(:project)
#     FactoryGirl.create(:task)
#     @login_page = LoginPage.new
#     @login_page.visit
#   end

#   scenario 'add valid comment without attachment' do
#     @login_page.sign_in(@user.email, @user.password)
#     visit '#/todo'

#     page.find('#task_id_0_text').click
#     page.find('#expand_comments_0').click

#     fill_in 'comment_text_input_0', with: 'Added comment'

#     page.find('#save_comment_btn_0').click

#     expect(page).to have_content('Added comment', wait: 10)
#     expect(page).to have_no_content('Text is too short')
#     expect(page.find('#comment_text_input_0')).to have_text ''
#   end

#   scenario 'add invalid comment without attachment' do
#     @login_page.sign_in(@user.email, @user.password)
#     visit '#/todo'

#     page.find('#task_id_0_text').click
#     page.find('#expand_comments_0').click

#     fill_in 'comment_text_input_0', with: ''

#     page.find('#save_comment_btn_0').click

#     expect(page).to have_no_content('Added comment', wait: 10)
#     expect(page).to have_content('Text is too short')
#   end

#   scenario 'add valid comment with attachment' do
#     @login_page.sign_in(@user.email, @user.password)
#     visit '#/todo'

#     page.find('#task_id_0_text').click
#     page.find('#expand_comments_0').click

#     @file = File.expand_path(File.dirname(__FILE__) + '/IMG_20140902_130119.jpg')

#     attach_file('comment_file_input_0', @file, visible: false, wait: 5)
#     page.find('#save_comment_btn_0').click

#     expect(page).to have_content('IMG_20140902_130119.jpg', wait: 60)
#     expect(page).to have_no_content('Text is too short')
#   end

#   scenario 'add comment with invalid attachment' do
#     @login_page.sign_in(@user.email, @user.password)
#     visit '#/todo'

#     page.find('#task_id_0_text').click
#     page.find('#expand_comments_0').click

#     @file = File.expand_path(File.dirname(__FILE__) + '/file.apk')

#     attach_file('comment_file_input_0', @file, visible: false)
#     page.find('#save_comment_btn_0').click

#     expect(page).to have_content('You are not allowed to upload "apk" files')
#     expect(page).to have_no_content('Text is too short')
#   end
# end
