FactoryGirl.define do
	factory :member do
		sequence(:first_name) { |n| "Per #{n}" }
		sequence(:last_name) { |n| "Son #{n}" }
		sequence(:email) { |n| "person_#{n}@example.com" }
		password "foobar"
		password_confirmation "foobar"
	end
end