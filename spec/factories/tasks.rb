FactoryBot.define do
  factory :task do
    sequence(:title){|n| "test#{n}" }
    content { 'test_content' }
    status { 'todo' }
    deadline { 1.week.from_now }
    association :user
  end
end
