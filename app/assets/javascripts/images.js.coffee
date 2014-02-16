# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
	$('#image_comments').perfectScrollbar({
		wheelSpeed: 10
	})
	
	$('.image_block').mouseenter ->
		$(this).children('.over_image').fadeIn()
	$('.image_block').mouseleave ->
		$(this).children('.over_image').delay(1000).fadeOut()

	if ( $('.show_image').length != 0)
		$('body').css('background-color', '#111')

	$('.file-upload').each ->
		if this.id == 'new_image'
			$(this).fileupload
				dropZone: $(this)
				formData: { 'member_id' : $('#image_member_id').val() }
				dataType: "script"
				replaceFileInput: false
				add: (e, data) ->
					$('#image_upload_submit').attr('disabled', false)
					types = /(\.|\/)(gif|jpe?g|png)$/i
					file = data.files[0]
					if types.test(file.type) || types.test(file.name)
						$('#image_upload_submit').click( ->
							event.preventDefault()
							data.context = $(tmpl("template-upload", file))
							$('#new_image').append(data.context)
							data.submit()
							$('#image_upload_submit').attr('disabled', true) )
					else
						alert("#{file.name} is not a gif, jpeg, or png image file")
				progress: (e, data) ->
					if data.context
						progress = parseInt(data.loaded / data.total * 100, 10)
						data.context.find('.bar').css('width', progress + '%')
						if progress == 100
							$('.upload').delay(5000).fadeOut('slow')
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
						data.context = $(tmpl("template-upload", file))
						$('#new_image').append(data.context)
						data.submit()
					else
						alert("#{file.name} is not a gif, jpeg, or png image file")
				progress: (e, data) ->
					if data.context
						progress = parseInt(data.loaded / data.total * 100, 10)
						data.context.find('.bar').css('width', progress + '%')
						if progress == 100
							$('.upload').delay(5000).fadeOut('slow')
		else if this.id == 'hidden_new_image'
			$(this).fileupload
				dropZone: $(this).parent()
				formData: { 'member_id' : $('#image_member_id').val() }
				dataType: "script"
				replaceFileInput: false
				add: (e, data) ->
					types = /(\.|\/)(gif|jpe?g|png)$/i
					file = data.files[0]
					if types.test(file.type) || types.test(file.name)
						data.context = $(tmpl("template-upload", file))
						$('#new_image').append(data.context)
						data.submit()
					else
						alert("#{file.name} is not a gif, jpeg, or png image file")
				progress: (e, data) ->
					if data.context
						progress = parseInt(data.loaded / data.total * 100, 10)
						data.context.find('.bar').css('width', progress + '%')
						if progress == 100
							$('.upload').delay(5000).fadeOut('slow')
		
	$(document).bind 'drop dragover', (e) ->
		e.preventDefault()


$(document).ready(ready)
$(document).on('page:load', ready)