require 'carrierwave/processing/mime_types'
# encoding: utf-8

class TmpImageUploader < CarrierWave::Uploader::Base

	include CarrierWave::MimeTypes
  # Include RMagick or MiniMagick support:
	include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
	storage :file
	# storage :fog
	
	def move_to_cache
		true
	end

	def move_to_store
		true
	end

	def filename
		 "#{secure_token}.#{file.extension}" if original_filename.present?
	end
	
	# Override the directory where uploaded files will be stored.
	# This is a sensible default for uploaders that are meant to be mounted:
	def store_dir
		"#{Rails.root}/public/uploads"
	end

	process :set_content_type

  # Provide a default URL as a default if there hasn't been a file uploaded:
  #	def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #		ActionController::Base.helpers.image_path([version_name, "default.png"].compact.join('_'))
		# "/images/fallback/" + [:thumb, "default.jpg"].compact.join('_')
  #	end

  # Process files as they are uploaded:
	resize_to_fit(800, 800)
  #

	process :get_geometry

	def geometry
		@geometry ||= get_geometry
	end
    
	def get_geometry
		if (@file)
			img = ::Magick::Image::read(@file.file).first
			@geometry = { width: img.columns, height: img.rows }
		end
	end

  # Create different versions of your uploaded files:
	version :medium do
		resize_to_fill(260,260)
	end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
	def extension_white_list
		%w(jpg jpeg gif png)
	end
	
	protected
		def secure_token
			var = :"@#{mounted_as}_secure_token"
			model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
		end

end