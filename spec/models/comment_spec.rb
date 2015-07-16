require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    FactoryGirl.create(:confirmed_user)
    FactoryGirl.create(:project)
    @task = FactoryGirl.create(:task)
    @comment = Comment.create({
                                  text: 'First comment',
                                  task_id: @task.id
                              })
  end

  it 'has one after adding one' do
    expect(Comment.all.count).to eq(1)
    expect(Comment.first.text).to eq('First comment')
  end

  it 'has associated task' do
    expect(@task.comments.first.text).to eq('First comment')
  end

  it "should validate comment's text length" do
    @comment = Comment.create({
                            text: 'a' * 141,
                            task_id: @task.id
                        })
    expect(@comment.errors[:text]).to match_array(['is too long (maximum is 140 characters)'])
  end

  it 'should be deleted when associated task was deleted' do
    @comment = Comment.create({
                            text: 'First comment',
                            task_id: @task.id
                        })
    @task.destroy
    expect(Comment.all.count).to eq(0)
  end
end