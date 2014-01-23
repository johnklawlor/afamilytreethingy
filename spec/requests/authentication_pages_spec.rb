require 'spec_helper'

describe "Authentication" do
	subject { page }
	
	describe "signin" do
		before do
			visit signin_path
		end

		describe "page" do		
			it { should have_selector('h1', text: 'Sign in') }
			it { should have_selector('title', text: 'Sign in') }
		end
		
		describe "with invalid information" do
			before do
				click_button "Sign in"
			end
			
			it { should have_selector('title', text: "my peeps | Sign in") }
			it { should have_selector('div.alert.alert-error', text: 'The username and password combination do not match our records. Please try again.') }
			
			describe "visiting another page should make alert disappear" do
				before { click_link 'Home' }
				it { should_not have_selector('div.alert.alert-error', text: 'The username and password combination do not match our records. Please try again.') }
			end
		end
		
		describe "with valid information" do
			let(:member) { FactoryGirl.create(:member) }
			before { sign_in member }
			
			it { should have_selector('title', text: member.first_name) }
			it { should have_link('Profile', href: member_path(member)) }
			it { should have_link('Sign out', href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }	
			
			describe "signing out" do
				before { click_link 'Sign out' }
			
				it { should have_link('Sign in', href: signin_path) }
				it { should_not have_link('Sign out', href: signout_path) }
			end		
		end
		
	end
end
