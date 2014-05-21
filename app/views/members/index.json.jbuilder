json.array! @members do |member|
	json.name member.id
	json.name member.name
	json.image member.image_url(:micro)
end