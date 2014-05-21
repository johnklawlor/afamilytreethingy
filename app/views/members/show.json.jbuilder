json.member @member, :first_name, :last_name
json.image @member.image_url(:medium)

json.posts @member.posts do |json, post|
	json.id post.id

	json.type ((post.content? && 'written') || (post.image? && 'image') || (post.video? && 'video'))
	from_member = Member.find_by_id(post.from_member)
	json.from_member_id post.from_member
	json.from_member_name from_member.first_name.downcase
	json.from_member_image from_member.image_url(:thumb)
	
	if post.content?
		json.content post.content
		json.comments post.comments do |json, comment|
			from_member = Member.find_by_id(comment.member_id)
			json.from_member_id from_member.id
			json.from_member_name from_member.first_name.downcase
			json.from_member_image from_member.image_url(:micro)
			json.content comment.content
			json.created_at time_ago_in_words(comment.created_at)
		end
	elsif post.image?
		json.image post.image_url(:medium)
	elsif post.video?
		json.video post.video_url(:medium)
	end
end