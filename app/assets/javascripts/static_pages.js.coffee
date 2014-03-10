# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
	rotateInBoxes = ->
		duration = 200
		jBox = $('.box')
		jBox.css( visibility: 'hidden')
		boxes = jBox.toArray()

		length = boxes.length
		i=0

		expandAndShow = ->
			$(boxes[i++]).css( visibility: 'visible').addClass('expand')
			if i < length
				setTimeout expandAndShow, duration
			else setTimeout ->
				$('#fb').fadeIn(1000)
			, 1500

		expandAndShow()
		setTimeout ->
			jBox.removeClass('expand')
		, 10000
	rotateInBoxes()

$(document).ready(ready)