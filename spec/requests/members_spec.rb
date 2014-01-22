require 'spec_helper'

describe "Members" do

	subject { page }
	
	describe "signup page" do
		before { visit signup_path }
		
		it { should have_selector('h1', text: "Sign up") }
		it { should have_selector('title', text: full_title('Sign up')) }
	end
	
	describe "signup" do
		before { visit signup_path }
		
		let(:submit) { "Create my account" }
		describe "with invalid information" do
			it "should not change number of members" do
				expect { click_button submit }.not_to change(Member, :count)
			end
		
			describe "after submission" do
				before { click_button submit }
			
				it { should have_selector('title', text: 'Sign up') }
				it { should have_content('error') }
			end
		end
		
		describe "with valid information" do
			before do
				fill_in "First name", with: "Bob"
				fill_in "Last name", with: "Lawlor"
				fill_in "Email", with: "bob@lawlor.com"
				fill_in "Password", with: "foobar"
				fill_in "Confirm Password", with: "foobar"
			end
			
			it "should change the number of members" do
				expect { click_button submit }.to change(Member, :count)
			end
		end
	end
end
