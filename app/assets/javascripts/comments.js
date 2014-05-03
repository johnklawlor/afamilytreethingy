function startStream(){
// we grab the member id from the post form in the images div. we then create a new EventSource that listens on this route
	member = $("#post_member_id")
	if( member.length != 0 ){
	
		member_id = member.val()
		console.log("Creating new EventSource stream...")
		var source = new EventSource("/members/" + member_id + "/events")
		console.log( source);
		source.addEventListener('comments.create', function (e) {
			console.log('e is ', e)
			if( e.data.length > 4) {
				console.log('e.data ', e.data)
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
		})
	}
}

var ready;

ready = function() {

	member = $("#post_member_id")
	if( member.length != 0 ){
		$(document).keydown(function(e){
			lastComment = $('body').attr('last-comment')
			if(lastComment && e.keyCode == 32){
				e.preventDefault();
			}
		})
		$(document).keyup(function(e){
			lastComment = $('body').attr('last-comment')
			if(e.keyCode == 32 && lastComment && lastComment.length != 0){
				$(".image_block#" + lastComment).find('.comment_link').click()
				$('body').attr('last-comment','')
			}
		})
	}
//	startStream();
//	refreshInterval = setInterval('window.location.href=window.location.href;', 25000);
	$(window).bind('beforeunload', function(e){
//		clearInterval(refreshInterval);
	})
}

$(document).ready(ready);
$(document).on('page:load', ready);