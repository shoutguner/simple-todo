require 'rails_helper'

RSpec.describe DownloadsController, type: :controller do

  render_views

  describe 'auth' do
    context 'restrict unauthorized access' do
      it 'download should respond with 401' do
        xhr :post, :download, format: :json, comment_id: 1, file_name: 'my_file'
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'download' do
    before do
      FactoryGirl.create(:confirmed_user)
      FactoryGirl.create(:project)
      FactoryGirl.create(:task)
      @comment = FactoryGirl.create(:comment)
      password = Faker::Internet.password(8)
      @user = User.create({
                            id: 2,
                            email: Faker::Internet.email,
                            password: password,
                            password_confirmation:password,
                            provider: 'email'
                        })
      sign_in @user
      xhr :post, :download, format: 'pdf', comment_id: @comment.id, file_name: 'my_file'
    end

    subject(:results) { JSON.parse(response.body) }

    context 'restrict access to file that non-owned by current user' do
      it 'should response with 200' do
        expect(results['errors']).to match_array(['You not own this file.'])
      end
    end
  end
end