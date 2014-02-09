class Relationship < ActiveRecord::Base
	belongs_to :parent, class_name: "Member"
	belongs_to :child, class_name: "Member"
	
	after_create :set_oldest_ancestor
	after_destroy :reset_oldest_ancestor	
	
	def set_oldest_ancestor
		parent = Member.find_by_id( parent_id)
		parent.oldest_ancestor.nil? ? oldest_ancestor = parent_id : oldest_ancestor = parent.oldest_ancestor
		
		parent.descendants.each do |d|
			d.oldest_ancestor = oldest_ancestor
			d.save
		end
		
		parent.oldest_ancestor = oldest_ancestor
		parent.save
	end
	
	def reset_oldest_ancestor
		parent = Member.find_by_id( parent_id)
		child = Member.find_by_id( child_id)
		child.parents.count == 1 ?
			oldest_ancestor = child.parents.first.oldest_ancestor
			: oldest_ancestor = child_id
		
		child.oldest_ancestor = oldest_ancestor
		child.save
		if child.has_children?
			child.descendants.each do |d|
				d.oldest_ancestor = oldest_ancestor
				d.save
			end
		end
	end
	
	validates :parent_id, presence: true
	validates :child_id, presence: true
	
	validate :not_own_parent_and_child
	
	def not_own_parent_and_child
		if parent_id == child_id
			errors.add( :parent_id, "- you cannot be your own parent or child")
		end
	end
end
