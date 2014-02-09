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
		f.hidden_field( :_destroy) + link_to_function( name, "remove_fields(this)")
	end
	
	def link_to_add_fields( name, f, association, partial, locals = {})
		new_object = f.object.class.reflect_on_association(association).klass.new
		fields = f.fields_for(association, new_object, child_index: "new_#{association }") do |r|
			render( "members/" + partial.to_s + "_fields", locals.merge!( f: f) )
		end
		link_to_function( name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
	end
end
