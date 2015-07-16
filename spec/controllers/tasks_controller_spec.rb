require 'rails_helper'

RSpec.describe TasksController, type: :controller do

  render_views

  describe 'auth' do
    context 'restrict unauthorized access' do
      it 'create should respond with 401' do
        xhr :post, :create, format: :json, project_id: 1
        expect(response.status).to eq(401)
      end

      it 'destroy should respond with 401' do
        xhr :delete, :destroy, format: :json, project_id: 1, id: 1
        expect(response.status).to eq(401)
      end

      it 'update should respond with 401' do
        xhr :put, :update, format: :json, project_id: 1, id: 1
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'create' do
    before do
      @user = FactoryGirl.create(:confirmed_user)
      @project = FactoryGirl.create(:project)
      sign_in @user
    end

    subject(:results) { JSON.parse(response.body) }

    context 'create new task in project' do
      it 'should respond with 200' do
        xhr :post, :create, format: :json, project_id: @project.id, task: { text: 'First project' }
        expect(response.status).to eq(200)
      end

      it 'last task text should be "Second project"' do
        xhr :post, :create, format: :json, project_id: @project.id, task: { text: 'Last project' }
        expect(@project.tasks.last.text).to eq('Last project')
      end

      it 'should respond with errors when trying to create task with non-uniq text in his project' do
        xhr :post, :create, format: :json, project_id: @project.id, task: { text: 'non-uniq text' }
        xhr :post, :create, format: :json, project_id: @project.id, task: { text: 'non-uniq text' }
        expect(results['errors']).to match_array(['Text has already been taken'])
      end
    end
  end

  describe 'destroy' do
    before do
      @user = FactoryGirl.create(:confirmed_user)
      @project = FactoryGirl.create(:project)
      @task = FactoryGirl.create(:task)
      sign_in @user
      xhr :delete, :destroy, format: :json, project_id: @project.id, id: @task.id
    end

    context 'delete existing task' do
      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end

      it 'should delete only task' do
        expect(@project.tasks.all.size).to eq(0)
      end
    end

    context 'delete non-existing task' do
      it 'should respond with 404 on non-existing task id' do
        xhr :delete, :destroy, format: :json, project_id: @project.id, id: 9999
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'update' do
    before do
      @user = FactoryGirl.create(:confirmed_user)
      @project = FactoryGirl.create(:project)
      @task = FactoryGirl.create(:task)
      sign_in @user
    end

    subject(:results) { JSON.parse(response.body) }

    context 'update existing task' do
      it 'should respond with 200' do
        xhr :put, :update, format: :json, project_id: @task.project_id, id: @task.id, task: { text: 'Updated text' }
        expect(response.status).to eq(200)
      end

      it 'should update task text' do
        xhr :put, :update, format: :json, project_id: @task.project_id, id: @task.id, task: { text: 'Updated text' }
        expect(@project.tasks.find(@task.id).text).to eq('Updated text')
      end

      it 'should respond with errors when trying to update task with blank name' do
        xhr :put, :update, format: :json, project_id: @task.project_id, id: @task.id, task: { text: '' }
        expect(results['errors']).to match_array(["Text can't be blank", 'Text is too short (minimum is 1 character)'])
      end

      it 'should respond with errors when trying to update task with too long name' do
        xhr :put, :update, format: :json, project_id: @task.project_id, id: @task.id, task: { text: 'a' * 141 }
        expect(results['errors']).to match_array(['Text is too long (maximum is 140 characters)'])
      end

      it 'should respond with errors when trying to update task with non-uniq name' do
        xhr :post, :create, format: :json, project_id: @project.id, task: { text: 'some text' }
        xhr :put, :update, format: :json, project_id: @task.project_id, id: @task.id, task: { text: 'some text' }
        expect(results['errors']).to match_array(['Text has already been taken'])
      end


      it 'should respond with errors when trying to update task with invalid deadline' do
        xhr :put, :update, format: :json, project_id: @task.project_id, id: @task.id, deadline: 'banana', task: { id: @task.id }
        expect(results['errors']).to match_array(['Deadline is not a valid datetime'])
      end

      it 'should change the priorities of two tasks when updating one of them' do
        xhr :post, :create, format: :json, project_id: @project.id, task: { text: 'some text' }
        xhr :put, :update, format: :json, project_id: @project.id, id: @task.id, direction: 'up'
        # moment ago they be like: id: 0, priority: 0; id: 5, priority: 5,
        # but now they are like:   id: 0, priority: 5; id: 5, priority: 0
        expect(@project.tasks.find(@task.id).priority).to_not eq(@task.id)
        expect(@project.tasks.last.priority).to_not eq(@project.tasks.last.id)
      end

      it "should not change task's priority, when there is only task in the project" do
        xhr :put, :update, format: :json, project_id: @project.id, id: @task.id, direction: 'down'
        expect(@project.tasks.find(@task.id).priority).to eq(0)
      end

      it "should not change task's priority, when invalid direction given" do
        xhr :put, :update, format: :json, project_id: @project.id, id: @task.id, direction: 'banana'
        expect(@project.tasks.find(@task.id).priority).to eq(0)
      end

      it 'should update task status' do
        xhr :put, :update, format: :json, project_id: @task.project_id, id: @task.id, invert_status: true,
                                                                        task: { not_used_but_needed_non_empty_param: 0 }
        expect(@project.tasks.find(@task.id).done).to eq(true)
      end
    end

    context 'update non-existing task' do
      it 'should respond with 404 on non-existing task id' do
        xhr :put, :update, format: :json, project_id: @task.project_id, id: 9999, task: { text: 'some text' }
        expect(response.status).to eq(404)
      end
    end
  end
end