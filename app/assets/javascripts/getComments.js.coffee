ready = ->
	image = $("#actual_image")
	image_id = image.attr('data-image')
	console.log( image_id)
	if image.length != 0
		myInterval = setInterval( ->
			$.ajax
				type: "POST",
				data: { 'post_id' : image_id }
				url: '/updates/comments'
			.always
				$(document).on 'page:change', ->
					clearInterval(myInterval)
		, 5000)
		
$(document).ready(ready)
$(document).on('page:load', ready)