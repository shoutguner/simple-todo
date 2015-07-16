require 'rails_helper'

RSpec.describe Project, type: :model do
  before do
    @user = FactoryGirl.create(:confirmed_user)
    @project = Project.create({
                                  name: 'Complete the task for Ruby Garage',
                                  user_id: @user.id
                              })
  end

  it 'has one after adding one' do
    expect(Project.all.count).to eq(1)
    expect(Project.first.name).to eq('Complete the task for Ruby Garage')
  end

  it 'has associated user' do
    expect(@user.projects.first.name).to eq('Complete the task for Ruby Garage')
  end

  it 'has associated task' do
    @project.tasks.create({ text: 'First task' })
    expect(@project.tasks.last.text).to eq('First task')
  end

  it 'destroy associated tasks when delete' do
    @project.tasks.create({ text: 'First task' })
    @project.destroy
    expect(Task.all.count).to eq(0)
  end

  it "should validate project's name" do
    @project = Project.create({
                                  name: '',
                                  user_id: @user.id
                              })
    expect(@project.errors[:name]).to match_array(["can't be blank", 'is too short (minimum is 1 character)'])
  end
end