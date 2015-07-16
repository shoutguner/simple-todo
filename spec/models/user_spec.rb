require 'rails_helper'

describe User do
  before do
    password = Faker::Internet.password(8)
    @user = User.create({
                            email: Faker::Internet.email,
                            password: password,
                            password_confirmation: password,
                            provider: 'email',
                            confirmed_at: Time.zone.now
                        })
  end

  it 'gets a uid assigned' do
    @user.save
    expect(@user.uid).not_to be_blank
  end

  it "doesn't send a confirmation email" do
    expect { @user.save }.not_to change { ActionMailer::Base.deliveries.count }
  end

  it 'has associated project' do
    @project = @user.projects.build({ name: 'Complete the task for Ruby Garage' })
    expect(@user.projects.last.name).to eq('Complete the task for Ruby Garage')
  end

  it 'destroy associated projects when delete' do
    @project = @user.projects.build({ name: 'Complete the task for Ruby Garage' })
    @user.destroy
    expect(Project.all.count).to eq(0)
  end
end