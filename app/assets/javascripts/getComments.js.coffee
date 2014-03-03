ready = ->
	image = $("#actual_image")
	image_id = image.attr('data-image')

	if image.length != 0
		myInterval = setInterval( ->
			most_recent_post = image.attr('data-most-recent-post')
			$.ajax
				type: "POST",
				data: { 'post_id' : image_id, 'most_recent_post' : most_recent_post }
				url: '/updates/comments'
			.always ->
				$(document).on 'page:change', ->
					clearInterval(myInterval)
		, 5000)
		
$(document).ready(ready)
$(document).on('page:load', ready)