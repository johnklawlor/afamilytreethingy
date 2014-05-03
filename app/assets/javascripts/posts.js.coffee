# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
	
	expanding = ->
		expand_collapse = $(this)
		expand_collapse.unbind 'click', expanding
		expand_collapse.addClass('rotate')
		written_post = $(this).parents('.image_block')
		height = written_post.attr('data-height')
		
		written_post.show().animate { 'height': "#{height}"+'px'}, 1000, ->
			expand_collapse.removeClass('rotate expand_convo').addClass('collapse_convo')
			expand_collapse.bind 'click', collapsing = ->
				expand_collapse.addClass('rotateBack')
				written_post.animate {'height': '330px'}, 1000, (e) ->
					expand_collapse.removeClass('rotateBack collapse_convo').addClass('expand_convo')
					expand_collapse.unbind 'click', collapsing
					expand_collapse.bind 'click', expanding
					
	$('.post').each ->
		written_post = $(this).parents('.image_block')
		written_post.hide().css( { 'height': 'initial' })
		setTimeout ->
			height = written_post.outerHeight()
			iheight = written_post.height()
			written_post.animate { height: '330px'}, 0, ->
				written_post
				written_post.attr( 'data-height', height)
				if height > 330
					console.log("outerheight is", height)
					console.log("innerheight is", iheight)
					written_post.append("<div class='expand_convo'></div>")
					$('.expand_convo').bind 'click', expanding
		, 1
	
	rotateInPosts = ->
		duration = 100
		$('.image_block').hide()
		posts = $('.image_block').toArray()
	
		length = posts.length
		i=0

		expandAndShow = ->
			$(posts[i++]).show().addClass('expand')
			if i < length
				setTimeout expandAndShow, duration
	
		expandAndShow()
		setTimeout ->
			$('.image_block').removeClass('expand')
		, 10000
	rotateInPosts()

# WE HAVE TO BIND EVENTS TO VIDEO TAG BEFORE VIDEO JS DOES ITS THINGS!
	$('video#actual_image').bind 'ended', ->
		$('.over_image_marker').addClass('over_image tp')
		
	if $('.show_post_video').length != 0
		videojs( $('.show_post_video')[0], {}, -> )
			
	loadVJS = ->	
		if $('body').find('.show_post_video').length != 0
			videojs( $('.show_post_video')[0], {}, -> )
		$('body').find('video#actual_image_html5_api').bind 'ended', ->
			$('.over_image_marker').addClass('over_image tp')
		
	$('body').on 'click', ->
		$('.member_image').colorbox
			rel: 'member_image'
			onComplete: loadVJS

	$('body').on 'click', '.vjs-big-play-button, .vjs-play-control', ->
		over_image = $(this).parents('#actual_image').siblings('.over_image_marker')
		over_image.attr( 'class', 'over_image_marker' )
		over_image.hide()

	if $('div#images').length != 0
		getPosts = setInterval( ->
			most_recent_post = $('#images').attr( 'data-most-recent-post')
			member_id = $('#post_member_id').val()
			console.log( most_recent_post)
			$.ajax
				type: "GET",
				url: '/updates/posts'
				data: { 'most_recent_post' : most_recent_post, 'member_id': member_id }
			.always ->
				$(document).on 'page:change', ->
					clearInterval(getPosts)
		, 20000)
		
	$('body').on 'click', '#post_submit', ->
		new_post = $("<div class='image_block new_post'></div>")
		$("#member_info").after( new_post)

	closeCommentForm = (textarea) ->
		post = textarea.closest('.image_block')
		post.off( 'mouseover')
		form_holder = textarea.closest( '.show_member_comment_form_holder')
		post.find( '.hidden_over_image').attr( 'class', 'over_image tp')
		post.find('p').fadeIn(1000)
		form_holder.fadeOut 1000, ->
			$(this).remove()

	$('body').on 'click', '.comment_link', ->
		$(document).keyup (e) ->
			if e.keyCode == 27
				closeCommentForm($(':focus'))
	
	$('body').on 'click', '.exit_button, #comment_submit, #post_submit', ->
		closeCommentForm($(this))
		
	$('body').on 'click', '#comment_submit', ->
		post_id = $(this).parents('.image_block').attr('id')
		console.log(post_id)
		$('body').attr('last-comment', post_id)

	overImageVisible = true
	$('body').on 'mouseover', '.image_block, .tree_image_block, .show_image', ->
		if overImageVisible == true
			overImage = $(this).children('.over_image')
			overImage.stop(true)
			overImage.css( 'opacity', 1 )
			overImageVisible = false
		$(this).children('.over_image').fadeIn()
		overImageVisible = true

	$('body').on 'mouseleave', '.image_block, .tree_image_block, .show_image', ->
		$(this).children('.over_image').delay(1000).fadeOut 1000, ->
			overImageVisible = false
	
	fadeOutOverImage = ->
		$('body').on 'click', ->
			$("#colorbox .over_image").hide()
		delay=4000
		fadeOutOverImageTimeout = setTimeout ->
			$('body').find('.over_image').fadeOut 1000, ->
				overImageVisible = false
		, delay
	fadeOutOverImage()
		
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
						if filesSent > 0
							alert( "You can only upload one photo to your profile page.")
							filesSent = 0
							return false
						else
							$('#progress_bar_section').show()
							data.submit()
					else
						alert("#{file.name} is not a gif, jpeg, or png image file")
				send: (e, data) ->
					filesSent += 1
				done: (e, data) ->
					filesSent = 0
				progressall: (e, data) ->
					progress = parseInt(data.loaded / data.total * 100, 10)
					$('#bar').css('width', progress + '%')
					if progress == 100
						$('#progress_bar_section').append("<span id='upload_complete'>Upload complete!</span>")
						$('#progress_bar_section').delay(5000).fadeOut('slow', ->
							$('#upload_complete').remove())
		else if this.id == 'hidden_new_post'
			filesSent = 0
			$(this).fileupload
				dropZone: $(this).parent()
				replaceFileInput: false
				add: (e, data) ->
					types = /(\.|\/)(gif|jpe?g|png|m4v)$/i
					file = data.files[0]
					if types.test(file.type) || types.test(file.name)
						if filesSent > 0 && $(this).find('input#post_member_id').val() != $(this).find('input#post_from_member').val()
							alert( "You can only post one photo or video at a time to another person's page")
							filesSent = 0
							return false
						else
							$('#progress_bar_section').fadeTo(200, 0.8)
							console.log(file.name)
							new_post = $("<div class='image_block new_post'></div>")
							$("#member_info").after( new_post)
							data.submit()
					else
						alert("#{file.name} is not a gif, jpeg, or png image file nor an mv4 video file")
				send: (e, data) ->
					filesSent += 1
				done: (e, data) ->
					filesSent = 0
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