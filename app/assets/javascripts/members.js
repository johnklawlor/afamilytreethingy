var ready;

ready = function() {

/* 	var source = new EventSource("/comments/events")
	source.onmessage = function(e) {
		if( e.data.length > 4) {
			console.log('e.data', e.data)
			data = $.parseJSON(e.data)
			comment = data.comment
			name = data.name
			sent_when = data.sent_when
			url = data.url
			console.log( data)
			div = "div#" + comment.post_id
			console.log( $(div).find('.post_comments') )
			$(div).find('.post_comments').prepend(" <li id='" + comment.id + "', class='comment_block'> <a href='/members/" + comment.member_id + "'> <img class='comment_member_image img-rounded' src='" + url + "' > </a> <a href='/members/" + comment.member_id + "'>" + name + "</a>: " + comment.content + "<br/> -" + sent_when + " | <a data-method='delete' data-remote='true' href='/comments/" + comment.id + "' rel='nofollow'>delete</a><br/> </li> ")
		}
	}
*/	
	$("form").on( "click", ".add_fields", function(event) {
		var time = new Date().getTime()
		var regexp = new RegExp($(this).data('id'), 'g')
		$(this).parent().before( $(this).data("fields").replace( regexp, time) )
		event.preventDefault()
	})

	if( $('#member_full_account').prop( 'checked' ) ) {
		$("#full_member_field").show('slow')
	}

	$('.add_fields').click( function() {
		$(this).parents('form').insertAfter( $(this).parents('div.row') )
		$(this).parent().next('input').fadeIn()
	})
}

$(document).ready(ready);
$(document).on('page:load', ready);

function remove_fields(link) {
	$(link).prev("input:hidden").val("1");
	$(link).closest(".relationship_fields").hide('slow');
	$(link).closest(".relationship_fields").nextAll("input:submit").hide('slow');
	form=$(link).parents('form')
	form.appendTo( form.prev());
}

function showFullForm(checkbox) {
	if( $(checkbox).prop( 'checked' ) ) {
		$(checkbox).parent().nextAll("#full_member_field").show('slow')
	}
	
	if( !$(checkbox).prop( 'checked' ) ) {
		$(checkbox).parent().nextAll("#full_member_field").hide('slow')
	}	
}