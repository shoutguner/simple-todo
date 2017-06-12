require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  render_views

  describe 'auth' do
    context 'restrict unauthorized access' do
      it 'index should respond with 401' do
        xhr :get, :index, format: :json
        expect(response.status).to eq(401)
      end

      it 'create should respond with 401' do
        xhr :post, :create, format: :json
        expect(response.status).to eq(401)
      end

      it 'destroy should respond with 401' do
        xhr :delete, :destroy, format: :json, id: 1
        expect(response.status).to eq(401)
      end

      it 'update should respond with 401' do
        xhr :put, :update, format: :json, id: 1, project: { id: 1, name: 'Updated name' }
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'root' do
    before do
      xhr :get, :root
    end

    context 'allow unauthorized access' do
      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'index' do
    before do
      @user = FactoryGirl.create(:confirmed_user)
      FactoryGirl.create(:project)
      sign_in @user
      xhr :get, :index, format: :json
    end

    subject(:results) { JSON.parse(response.body) }

    context 'show find projects' do
      it 'should response with 200' do
        expect(response.status).to eq(200)
      end

      it 'should return one project' do
        expect(results.size).to eq(1)
      end

      it 'should include Complete the task for Ruby Garage' do
        expect(results.map(&extract_name)).to include('Complete the task for Ruby Garage')
      end
    end
  end

  describe 'create' do
    before do
      @user = FactoryGirl.create(:confirmed_user)
      sign_in @user
    end

    subject(:results) { JSON.parse(response.body) }

    context 'create new project' do
      it 'should respond with 200' do
        xhr :post, :create, format: :json, project: { name: 'Newest project' }
        expect(response.status).to eq(200)
      end

      it 'last project name should be "Newest project"' do
        xhr :post, :create, format: :json, project: { name: 'Newest project' }
        expect(Project.last.name).to eq('Newest project')
      end

      it 'should respond with errors when trying to create project with blank name' do
        xhr :post, :create, format: :json, project: { name: '' }
        expect(results['errors']).to match_array(["Name can't be blank", 'Name is too short (minimum is 1 character)'])
      end

      it 'should respond with errors when trying to create project with too long name' do
        xhr :post, :create, format: :json, project: { name: 'a' * 51 }
        expect(results['errors']).to match_array(['Name is too long (maximum is 50 characters)'])
      end
    end
  end

  describe 'destroy' do
    before do
      @user = FactoryGirl.create(:confirmed_user)
      @project = FactoryGirl.create(:project)
      sign_in @user
      xhr :delete, :destroy, format: :json, id: @project.id
    end

    context 'delete existing project' do
      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end

      it 'should delete only project' do
        expect(Project.all.size).to eq(0)
      end
    end

    context 'delete non-existing project' do
      it 'should respond with 404 on non-existing project id' do
        xhr :delete, :destroy, format: :json, id: 9999
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'update' do
    before do
      @user = FactoryGirl.create(:confirmed_user)
      @project = FactoryGirl.create(:project)
      sign_in @user
    end

    subject(:results) { JSON.parse(response.body) }

    context 'update existing project' do
      it 'should respond with 200' do
        xhr :put, :update, format: :json, id: @project.id, project: { name: 'Updated name' }
        expect(response.status).to eq(200)
      end

      it 'should update project name' do
        xhr :put, :update, format: :json, id: @project.id, project: { name: 'Updated name' }
        expect(Project.find(@project.id).name).to eq('Updated name')
      end

      it 'should respond with errors when trying to update project with invalid name' do
        xhr :put, :update, format: :json, id: @project.id, project: { name: '' }
        expect(results['errors']).to match_array(["Name can't be blank", 'Name is too short (minimum is 1 character)'])
      end
    end

    context 'update non-existing project' do
      it 'should respond with 404 on non-existing project id' do
        xhr :put, :update, format: :json, id: 9999, project: { name: 'Some name' }
        expect(response.status).to eq(404)
      end
    end
  end

  private

  def extract_name
    ->(object) { object['name'] }
  end
end
