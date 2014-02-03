var ready;

ready = function() {
	if ( $("#member_full_account").prop( 'checked' ) ){
		$("#member_email_field").show()
	}

	$("#member_full_account").click( function() {
		$("#member_email_field").toggle("slow")
	})
}

$(document).ready(ready);
$(document).on('page:load', ready);