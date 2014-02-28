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

$(document).ready(ready)
$(document).on('page:load', ready)