function startStream(){
// we grab the member id from the post form in the images div. we then create a new EventSource that listens on this route
	member = $("#post_member_id")
	if( member.length != 0 ){
	
		member_id = member.val()
		console.log("Creating new EventSource stream...")
		var source = new EventSource("/stream/" + member_id + "/comments")
		console.log( source);
		source.addEventListener('comments.create.' + member_id, function (e) {
			console.log('e is ', e)
			console.log('e.data.length is ', e.data.length)
			if( e.data.length > 6) {
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
		$(window).bind('beforeunload', function(e){
			console.log("About to close... ",source);
			source.close();
		})
	}
}

var ready;

ready = function() {

	member = $("#post_member_id")
	if( member.length != 0 ){
		$(document).keydown(function(e){
			lastComment = $('body').attr('last-comment')
			console.log(lastComment.length)
			if(lastComment && e.keyCode == 32){
				e.preventDefault();
			}
			if(e.keyCode == 13){
				focused = $(':focus')
				if((focused.attr('id') == 'comment_content' || 'post_content') &&
					(focused.attr('id') != 'comment_submit' && 'post_submit')){
					e.preventDefault();
				}
			}
		})
		$(document).keyup(function(e){
			lastComment = $('body').attr('last-comment')
			console.log(lastComment.length)
			if(e.keyCode == 32 && lastComment && lastComment.length != 0){
				$('body').attr('last-comment','')
				$('.comment_link').qtip('destroy')
				$(".image_block#" + lastComment).find('.comment_link').click()
			}
			if(e.keyCode == 13){
				focused = $(':focus')
				if((focused.attr('id') == 'comment_content' || 'post_content') &&
					(focused.attr('id') != 'comment_submit' && 'post_submit')){
					e.preventDefault();
					focused.nextAll(':submit').click();
				}
			}
		})
		$("body").on('click', '.comment_link', function() {
			$('body').attr('last-comment','')
		})
	}

	startStream();

}

$(document).ready(ready);
$(document).on('page:load', ready);