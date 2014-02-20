class Comment < ActiveRecord::Base

	after_create :create_update
	
	def create_update
		image = Image.find_by_id( self.image_id)
		image.updates.create( what: 'comment', what_id: self.id)
	end
end
