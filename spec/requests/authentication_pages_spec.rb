require 'spec_helper'

describe "Authentication" do
	subject { page }
	
	describe "signin" do
		before { visit signin_path }

		describe "page" do
		
			it { should have_selector('h1', text: 'Sign in') }
			it { should have_selector('title', text: 'Sign in') }
		end
		
		describe "with invalid information" do
			before { click_button "Sign in" }
			
			it { should have_selector('title', 'Sign in') }
			it { should have_selector('div.alert.alert-error', text: 'Invalid') }
			
			describe "visiting another page should make alert disappear" do
				before { click_link 'Home' }
				it { should_not have_selector('div.alert.alert-error', text: 'Invalid') }
			end
		end
		
		describe "with valid information" do
			let(:member) { FactoryGirl.create(:member) }
			before do
				fill_in "Email", with: member.email
				fill_in "Password", with: member.password
				click_button "Sign in"
			end
			
			it { should have_selector('title', text: member.name) }
			it { should have_link('Profile', href: user_path(member)) }
			it { should have_link('Sign out', href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }			
		end
	end
end
