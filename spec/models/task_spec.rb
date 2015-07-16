require 'rails_helper'

RSpec.describe Task, type: :model do
  before do
    FactoryGirl.create(:confirmed_user)
    @project = FactoryGirl.create(:project)
    @task = Task.create({
                            text: 'First task',
                            project_id: @project.id
                        })
  end

  it 'has one after adding one' do
    expect(Task.all.count).to eq(1)
    expect(Task.first.text).to eq('First task')
  end

  it 'has a priority assigned' do
    expect(@task.priority).to eq(@task.id)
  end

  it 'has done status false assigned' do
    expect(@task.done).to eq(false)
  end

  it 'has associated project' do
    expect(@project.tasks.first.text).to eq('First task')
  end

  it 'has associated comment' do
    @task.comments.create({ text: 'First comment' })
    expect(@project.tasks.last.text).to eq('First task')
  end

  it 'destroy associated comments when delete' do
    @task.comments.create({ text: 'First comment' })
    @task.destroy
    expect(Comment.all.count).to eq(0)
  end

  it 'should return false when invalid direction given' do
    result = Task.change_priority(@project.id, @task.id, @task.priority, 'banana')
    expect(result).to eq(false)
  end

  it "should validate task's name length" do
    @task = Task.create({
                            text: '',
                            project_id: @project.id
                        })
    expect(@task.errors[:text]).to match_array(["can't be blank", 'is too short (minimum is 1 character)'])
  end

  it "should validate task's name uniqueness" do
    @task = Task.create({
                            text: 'First task',
                            project_id: @project.id
                        })
    expect(@task.errors[:text]).to match_array(['has already been taken'])
  end
end