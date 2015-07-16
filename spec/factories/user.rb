FactoryGirl.define do
  factory :user do
    id 1
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    password_confirmation { password }
    provider 'email'

    factory :confirmed_user do
      confirmed_at Time.zone.now
    end
  end
end