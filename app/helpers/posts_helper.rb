module PostsHelper

	def wrap_links( content)
		str = Regexp.escape("http://")
		start_str = content.index(str)
		if start_str.nil?
			return content
		else
			end_str = (content.index(" ", start_str) || content.length)
			olink = content[start_str, end_str-start_str]
			url = content[start_str, end_str-start_str]
			link = link_to( url, url, target: '_blank', class: 'post_link')
			new_content = "".html_safe
			new_content << content[0, start_str]
			new_content << "<br/>".html_safe
			new_content << link
			new_content << "<br/>".html_safe
			new_content << content[end_str, content.length]
		end
	end

end