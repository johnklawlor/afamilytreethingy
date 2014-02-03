class TreeController < ApplicationController
	before_filter :signed_in_filter

	def show
		member = Member.find_by_id(params[ :id])
		oldest_ancestor = Member.find_by_id(member.oldest_ancestor)

		@family = build_tree(oldest_ancestor)
	end

	def edit
		@member = Member.find_by_id(params[ :id])
		@parents = @member.parents.order('birthdate')
		@children = @member.children.order('birthdate')
	end

	def update
	end
end
