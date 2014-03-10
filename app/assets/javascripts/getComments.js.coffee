
ready = ->
	image = $("#actual_image")
	image_id = image.attr('data-image')

	if image.length != 0
		getComments = setInterval( ->
			most_recent_comment = image.attr('data-most-recent-comment')
			$.ajax
				type: "GET",
				url: '/updates/comments'
				data: { 'post_id' : image_id, 'most_recent_comment' : most_recent_comment }
			.always ->
				$(document).on 'page:change', ->
					clearInterval(getComments)
		, 5000)
		
$(document).ready(ready)
$(document).on('page:load', ready)