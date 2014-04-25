module ApplicationHelper
	def full_title(page_title)
	base_title = "my peeps"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end
	
	def full_name(first_name, last_name)
		"#{first_name} #{last_name}"
	end
	
	def link_to_remove_fields( name, f)
#		f.hidden_field( :_destroy) + link_to_function( name, "remove_fields(this)", class: 'remove_fields')
		f.hidden_field( :_destroy) + link_to( name, "#", class: 'remove_fields')
	end
	
	def link_to_add_fields( name, f, association, partial, locals = {})
		new_object = f.object.send(association).klass.new
		id = new_object.object_id
		fields = f.fields_for(association, new_object, child_index: id) do |r|
			render( "members/" + partial.to_s + "_fields", locals.merge!( f: r) )
		end
		link_to( name, '#', class: "add_fields", data: { id: id, fields: fields.gsub("\n", "") })
	end
end
