ready = ->
	scroll_if_anchor = (href) ->
		if typeof(href) != "string"
			href = $(this).attr("href");
			href = href.substr(href.indexOf('#'));
		
		if !href then return false

		fromTop = 55;

		if href.charAt(0) == "#"
			$target = $(href);
			if $target.length
				$('html, body').animate({ scrollTop: $target.offset().top - fromTop });
				if history && "pushState" in history
					history.pushState({}, document.title, window.location.pathname + href);
					return false;

	scroll_if_anchor(window.location.hash)
	$("body").on("click", "a", scroll_if_anchor)

	new AvatarCropper()
	
	updates_count = $('div#updates_count')
	my_profile_link = $('#my_profile_link')

	updates_count.mouseenter ->
		$(this).css( 'z-index', 20)
		$(this).css( 'cursor', 'pointer')
	updates_count.mouseout ->
		$(this).css( 'z-index', 0)
	
	my_profile_link.mouseenter ->
		updates_count.fadeTo 500, 0.5, ->
			mouseenterComplete = true
	my_profile_link.mouseout ->
			updates_count.stop(true)
			updates_count.css( 'opacity', 1)
			
	updates_count.click ->
		$(this).text('Up')
		path = $('#my_profile_link').attr('href')
		id = path.replace( "/members/", '')
		$.ajax
			type: "PATCH"
			url: path
			data: { id: id, member: { 'last_checked_updates' : new Date().getTime() } }

	updates_count.qtip
		content:
			text: (e, api) ->
				return $.ajax
					url: '/updates/updates'
					method: 'GET'
				.then (content) ->
					updates = updates_count.attr('data-updates')
					console.log( updates )
					return updates
				, (xhr, status, error) ->
					api.set( 'content.text', status + ': ' + error)
				return 'Loading...'
			title: $(updates_count).attr('data-title')
		show: 'click',
		hide: {
			event: 'click unfocus'
			fixed: true
			effect: ->
				$(this).slideUp(1000)
			delay: 0
		}
		style: { classes: 'qtip-transparent qtip-rounded' }

class AvatarCropper
	constructor: ->
		$('#cropbox').Jcrop
			aspectRatio: 1
			setSelect: [0, 0, 200, 200]
			onSelect: @update
			onChange: @update

	update: (coords) =>
		$('#member_crop_x').val(coords.x)
		$('#member_crop_y').val(coords.y)
		$('#member_crop_w').val(coords.w)
		$('#member_crop_h').val(coords.h)
		@updatePreview(coords)
	
	updatePreview: (coords) =>
		$('#preview').css
			width: Math.round(100/coords.w * $('#cropbox').width()) + 'px'
			height: Math.round(100/coords.h * $('#cropbox').height()) + 'px'
			marginLeft: '-' + Math.round(100/coords.w * coords.x) + 'px'
			marginTop: '-' + Math.round(100/coords.h * coords.y) + 'px'

$(document).ready(ready)
$(document).on('page:load', ready)