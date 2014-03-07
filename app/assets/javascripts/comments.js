var ready;

ready = function() {

	var source = new EventSource("/comments/events")
	console.log( source);
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
}

//$(document).ready(ready);