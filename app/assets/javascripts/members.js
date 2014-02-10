var ready;

ready = function() {

	$("form").on( "click", ".add_fields", function(event) {
		console.log( "yes, son")
		var time = new Date().getTime()
		var regexp = new RegExp($(this).data('id'), 'g')
		$(this).parent().before( $(this).data("fields").replace( regexp, time) )
		event.preventDefault()
	})

}

$(document).ready(ready);
$(document).on('page:load', ready);

function remove_fields(link) {
	$(link).prev("input:hidden").val("1");
	$(link).closest(".relationship_fields").hide('slow');
	$(link).parent().next("input:submit").hide('slow');
}

function showFullForm(checkbox) {
	if( $(checkbox).prop( 'checked' ) ) {
		$(checkbox).parent().prevAll("#full_member_field").show('slow')
	}
	
	if( !$(checkbox).prop( 'checked' ) ) {
		$(checkbox).parent().prevAll("#full_member_field").hide('slow')
	}	
}