FactoryBot.define do
  factory :site_visit do
    sequence(:session_id) { |n| "session_#{n}" }
    visit_time { Time.current }
    path { "/test-path-#{rand(1000)}" }
  end
end
