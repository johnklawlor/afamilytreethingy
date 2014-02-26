ready = ->
	image = $("#actual_image")
	image_id = image.attr('data-image')
	if image.length != 0
		myInterval = setInterval( ->
			$.ajax
				type: "GET",
				data: { 'image_id': image_id }
				url: '/updates/comments'
		, 5000)
		console.log(myInterval)

	$(document).on 'page:change', ->
		clearInterval(myInterval)
		
$(document).ready(ready)
$(document).on('page:load', ready)