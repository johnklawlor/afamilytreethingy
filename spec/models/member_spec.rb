require 'spec_helper'

describe Member do
	before do
		@member = Member.new(first_name: "Joey", last_name: "Gaba", email: "joeygama@example.com", password: "foobar", password_confirmation: "foobar")
	end
	
	subject { @member }
	
	it { should respond_to(:first_name) }
	it { should respond_to(:last_name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:remember_token) }
	it { should respond_to(:admin) }
	
	it { should be_valid }
	it { should_not be_admin }
	
	describe "accessible attributes" do
		it "should not allow access to admin" do
			expect do
				Member.new(admin: true)
			end .should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end
	
	describe "when first name is not present" do
		before { @member.first_name = " " }
		it { should_not be_valid }
	end
	
	describe "when last name is not present" do
		before { @member.last_name = " " }
		it { should_not be_valid }
	end
	
	describe "when email is not present" do
		before { @member.email = " " }
		it { should_not be_valid }
	end
	
	describe "when email format is invalid" do
		it "should be invalid" do
			address = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
			address.each do |invalid_address|
			@member.email = invalid_address
			@member.should_not be_valid
			end
		end
	end
	
	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[ user@foo.COM A_US-ER@f.b.org frst.last@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@member.email = valid_address
				@member.should be_valid
			end
		end
	end
	
	describe "when email address is already taken" do
		before do
			member_with_same_email = @member.dup
			member_with_same_email.save
		end
		
		it { should_not be_valid }
	end
	
	describe "when password is not present" do
		before { @member.password = @member.password_confirmation = " " }
		it { should_not be_valid }
	end
	
	describe "when password doesn't match confirmation" do
		before { @member.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end
	
	describe "when password confirmation is nil" do
		before { @member.password_confirmation = nil }
		it { should_not be_valid }
	end
	
	describe "return value of authenticate method" do
		before { @member.save }
		let(:found_member) { Member.find_by_email(@member.email) }
		
		describe "with valid password" do
			it { should == found_member.authenticate(@member.password) }
		end
		
		describe "with invalid password" do
			let(:member_with_invalid_password) { found_member.authenticate("invalid") }
			
			it { should_not == member_with_invalid_password }
			specify { member_with_invalid_password.should be_false }
		end
	end
	
	describe "with a password that's too short" do
		before { @member.password = @member.password_confirmation =  "a" * 5 }
		it { should_not be_valid }
	end
	
	describe "email address with mixed case" do
		let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
		
		it "should be save as all lower-case" do
			@member.email = mixed_case_email
			@member.save
			@member.reload.email.should == mixed_case_email.downcase
		end
	end
end