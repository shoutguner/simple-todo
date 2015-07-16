require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  render_views

  describe 'auth' do
    context 'restrict unauthorized access' do
      it 'create should respond with 401' do
        xhr :get, :create, format: :json, project_id: 1, task_id: 1
        expect(response.status).to eq(401)
      end

      it 'create should respond with 401' do
        xhr :post, :create, format: :json, project_id: 1, task_id: 1
        expect(response.status).to eq(401)
      end

      it 'destroy should respond with 401' do
        xhr :delete, :destroy, format: :json, project_id: 1, task_id: 1, id: 1
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'index' do
    before do
      @user = FactoryGirl.create(:confirmed_user)
      FactoryGirl.create(:project)
      @task = FactoryGirl.create(:task)
      FactoryGirl.create(:comment)
      sign_in @user
      xhr :get, :index, format: :json, project_id: @task.project_id, task_id: @task.id
    end

    subject(:results) { JSON.parse(response.body) }

    context 'show find comments' do
      it 'should response with 200' do
        expect(response.status).to eq(200)
      end

      it 'should return one comment' do
        expect(results.size).to eq(1)
      end

      it 'should have comment with text "First comment"' do
        expect(@task.comments.last.text).to eq('First comment')
      end
    end
  end

  describe 'create' do
    before do
      @user = FactoryGirl.create(:confirmed_user)
      FactoryGirl.create(:project)
      @task = FactoryGirl.create(:task)
      sign_in @user
    end

    subject(:results) { JSON.parse(response.body) }

    context 'create new comment in task' do
      it 'should respond with 200' do
        xhr :post, :create, format: :json, project_id: @task.project_id, task_id: @task.id, comment: { text: 'First comment' }
        expect(response.status).to eq(200)
      end

      it 'last comment text should be "First comment"' do
        xhr :post, :create, format: :json, project_id: @task.project_id, task_id: @task.id, comment: { text: 'First comment' }
        expect(@task.comments.last.text).to eq('First comment')
      end

      it 'should respond with errors when too long text' do
        xhr :post, :create, format: :json, project_id: @task.project_id, task_id: @task.id, comment: { text: 'a' * 141 }
        expect(results['errors']).to match_array(['Text is too long (maximum is 140 characters)'])
      end
    end
  end

  describe 'destroy' do
    before do
      @user = FactoryGirl.create(:confirmed_user)
      FactoryGirl.create(:project)
      @task = FactoryGirl.create(:task)
      @comment = FactoryGirl.create(:comment)
      sign_in @user
      xhr :delete, :destroy, format: :json, project_id: @task.project_id, task_id: @task.id, id: @comment.id
    end

    context 'delete existing comment' do
      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end

      it 'should delete only comment' do
        expect(@task.comments.all.size).to eq(0)
      end
    end

    context 'delete non-existing comment' do
      it 'should respond with 404 on non-existing task id' do
        xhr :delete, :destroy, format: :json, project_id: @task.project_id, task_id: @task.id, id: 9999
        expect(response.status).to eq(404)
      end
    end
  end
end