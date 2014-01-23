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
	
	describe "profile page" do
		let(:member) { FactoryGirl.create(:member) }
		before { visit member_path(member) }
		
		it { should have_selector('h1', text: "#{member.first_name} #{member.last_name}") }
		it { should have_selector('title', text: "#{member.first_name}") }
	end
	
	describe "members page" do
		
		let(:member) { FactoryGirl.create(:member) }
		before(:all) { 30.times { FactoryGirl.create(:member) } }
		after(:all) { Member.delete_all }
	
		before do
			sign_in member
			visit members_path
		end
		
		it { should have_selector('title', text: "Who's who") }
		it { should have_selector('h1', text: "Who's who") }
		
		describe "pagination" do
			it "should list each member" do
				Member.paginate(page: 1).each do |member|
					page.should have_selector('li', text: "#{member.first_name} #{member.last_name}")
				end
			end
		end
	end
end
