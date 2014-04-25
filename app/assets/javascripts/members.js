var ready;

ready = function() {

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
	
	$('.remove_fields').click( function () {
		$(this).prev("input:hidden").val("1");
		$(this).closest(".relationship_fields").hide('slow');
		$(this).closest(".relationship_fields").nextAll("input:submit").hide('slow');
		form=$(this).parents('form')
		form.appendTo( form.prev());		
	})
}

$(document).ready(ready);
$(document).on('page:load', ready);

function showFullForm(checkbox) {
	if( $(checkbox).prop( 'checked' ) ) {
		$(checkbox).parent().nextAll("#full_member_field").show('slow')
	}
	
	if( !$(checkbox).prop( 'checked' ) ) {
		$(checkbox).parent().nextAll("#full_member_field").hide('slow')
	}	
}