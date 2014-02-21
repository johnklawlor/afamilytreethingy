class TreeController < ApplicationController
	before_filter :signed_in_filter
	before_filter :correct_member, only: [ :edit]

	def show
		member = Member.find_by_id(params[ :id])
		oldest_ancestor = Member.find_by_id(member.oldest_ancestor)

		@family = build_tree(oldest_ancestor, oldest_ancestor.id)
	end

	def edit
		@member = Member.find_by_id(params[ :id])
	end

	def update
		
	end
end
