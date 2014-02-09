var ready;

ready = function() {

}

$(document).ready(ready);
$(document).on('page:load', ready);

function remove_fields(link) {
	$(link).prev("input:hidden").val("1");
	$(link).closest(".relationship_fields").hide('slow');
	$(link).parent().next("input:submit").hide('slow');
}

function add_fields( link, association, content) {
	var new_id = new Date().getTime();
	var regexp = new RegExp("new_" + association, "g")
	$(link).parent().before(content.replace(regexp, new_id)).show();
}

function showFullForm(checkbox) {
	if( $(checkbox).prop( 'checked' ) ) {
		$(checkbox).parent().prevAll("#full_member_field").show('slow')
	}
	
	if( !$(checkbox).prop( 'checked' ) ) {
		$(checkbox).parent().prevAll("#full_member_field").hide('slow')
	}	
}