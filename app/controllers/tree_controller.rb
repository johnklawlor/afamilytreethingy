class TreeController < ApplicationController
	def show
		member = Member.find_by_id(params[ :id])
		oldest_ancestor = Member.find_by_id(member.oldest_ancestor)

		@family = build_tree(oldest_ancestor).to_json.html_safe

		respond_to do |format|
			format.js
			format.html
		end
	end

	def edit
		@member = Member.find_by_id(params[ :id])
		@parents = @member.parents.order('birthdate')
		@children = @member.children.order('birthdate')
	end

	def update
	end
end
