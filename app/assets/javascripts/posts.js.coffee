# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# 	source = new EventSource('/posts/events')
#	source.onmessage = (e) ->

ready = ->
	setInterval( ->
		$.ajax
			type: "POST",
			url: '/updates/posts'
	, 10000)
	
	overImageVisible = true
	
	$('body').on 'mouseenter', '.image_block, .tree_image_block, .show_image', ->
		if overImageVisible == true
			overImage = $(this).children('.over_image')
			overImage.stop(true)
			overImage.css( 'opacity', 1 )
			overImageVisible = false
		$(this).children('.over_image').fadeIn()
		overImageVisible = true

	$('body').on 'mouseleave', '.image_block', ->
		$(this).children('.over_image').delay(1000).fadeOut( 1000, ->
			overImageVisible = false
		)
	
	delay=3000
	timeout=setTimeout( ->
		$('.over_image').fadeOut(1000, ->
			overImageVisible = false)
	, delay)
		
	$('#image_comments').perfectScrollbar({
		wheelSpeed: 10
	})

	if ( $('.show_image').length != 0)
		$('body').css('background-color', '#111')

	$('.file-upload').each ->
		if this.id == 'new_image'
			$(this).fileupload
				dropZone: $(this)
				formData: { 'member_id' : $('#post_member_id').val() }
				dataType: "script"
				replaceFileInput: false
				add: (e, data) ->
					$('#image_upload_submit').attr('disabled', false)
					types = /(\.|\/)(gif|jpe?g|png)$/i
					file = data.files[0]
					if types.test(file.type) || types.test(file.name)
						$('#image_upload_submit').click( ->
							event.preventDefault()
							$('#progress_bar_section').show()
							data.submit()
							$('#image_upload_submit').attr('disabled', true) )
					else
						alert("#{file.name} is not a gif, jpeg, or png image file")
				progressall: (e, data) ->
					progress = parseInt(data.loaded / data.total * 100, 10)
					$('#bar').css('width', progress + '%')
					if progress == 100
						$('#progress_bar_section').append("<span id='upload_complete'>Upload complete!</span>")
						$('#progress_bar_section').delay(5000).fadeOut('slow', ->
							$('#upload_complete').remove())
		else if this.id == 'hidden_profile_image'
			$(this).fileupload
				type: "PATCH"
				dropZone: $(this).parent()
				formData: { 'member_id' : $('#image_member_id').val() }
				dataType: "script"
				replaceFileInput: false
				add: (e, data) ->
					types = /(\.|\/)(gif|jpe?g|png)$/i
					file = data.files[0]
					if types.test(file.type) || types.test(file.name)
						$('#progress_bar_section').show()
						data.submit()
					else
						alert("#{file.name} is not a gif, jpeg, or png image file")
				progressall: (e, data) ->
					progress = parseInt(data.loaded / data.total * 100, 10)
					$('#bar').css('width', progress + '%')
					if progress == 100
						$('#progress_bar_section').append("<span id='upload_complete'>Upload complete!</span>")
						$('#progress_bar_section').delay(5000).fadeOut('slow', ->
							$('#upload_complete').remove())
		else if this.id == 'hidden_new_image'
			data = { member_id: $('#post_member_id').val(), from_member : $('#post_from_member').val() }
			console.log( data)
			$(this).fileupload
				dropZone: $(this).parent()
				formData: data
				dataType: "script"
				replaceFileInput: false
				add: (e, data) ->
					types = /(\.|\/)(gif|jpe?g|png)$/i
					file = data.files[0]
					if types.test(file.type) || types.test(file.name)
						$('#progress_bar_section').fadeTo(200, 0.8)
						data.submit()
					else
						alert("#{file.name} is not a gif, jpeg, or png image file")
				progressall: (e, data) ->
					progress = parseInt(data.loaded / data.total * 100, 10)
					$('#bar').css('width', progress + '%')
					if progress == 100
						$('#progress_bar_section').append("<span id='upload_complete'>Upload complete!</span>")
						$('#progress_bar_section').delay(5000).fadeOut('slow', ->
							$('#upload_complete').remove())
		
	$(document).bind 'drop dragover', (e) ->
		e.preventDefault()


$(document).ready(ready)
$(document).on('page:load', ready)