FactoryGirl.define do
  factory :task do
    id 0
    text 'First task'
    priority 0
    done false
    project_id 0
  end
end