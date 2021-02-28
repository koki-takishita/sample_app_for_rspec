FactoryBot.define do
  factory :task do
    sequence(:title){|n| "test#{n}" }
    sequence(:content){|n| "test_content#{n}"}
    status { 'todo' }
    deadline { 1.week.from_now }
    association :user
  end
end
