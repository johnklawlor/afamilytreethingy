class SpouseRelationship < ActiveRecord::Base
	
	belongs_to :member, class_name: "Member"
	belongs_to :spouse, class_name: "Member"
	
	validates :member_id, presence: true
	validates :spouse_id, presence: true
	validate :not_own_spouse
	
	after_create :create_inverse_spouse_relationship, unless: :inverse_exists?
	after_create :set_spouse_id
	after_destroy :reset_spouse_id_and_destroy_inverse_relationship, if: :inverse_exists?
	
	def reset_spouse_id_and_destroy_inverse_relationship
		member = Member.find_by_id( member_id)
		spouse = Member.find_by_id( spouse_id)
		other_relationship = SpouseRelationship.where(member_id: spouse.id, spouse_id: member.id).first
		
		member.spouse_id = nil
		member.save
		spouse.spouse_id = nil
		spouse.save
		
		other_relationship.destroy
	end
	
	def set_spouse_id
		member = Member.find_by_id( member_id)
		member.spouse_id = spouse_id
		member.save
	end
	
	def inverse_exists?
		SpouseRelationship.where(member_id: self.spouse_id, spouse_id: member_id).any?
	end
	
	def create_inverse_spouse_relationship
		SpouseRelationship.create( member_id: self.spouse_id, spouse_id: self.member_id)
	end
	
	def not_own_spouse
		if member_id == spouse_id
			errors.add( :spouse_id, "- you cannot be your own spouse")
		end
	end

end
