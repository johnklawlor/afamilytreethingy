# encoding: utf-8

class TmpVideoUploader < CarrierWave::Uploader::Base

	include CarrierWave::Video  # for your video processing
	include CarrierWave::Video::Thumbnailer
	# Include RMagick or MiniMagick support:
	# include CarrierWave::RMagick
	# include CarrierWave::MiniMagick

	# Choose what kind of storage to use for this uploader:
	# storage :file
	storage :fog

	def filename
		"#{secure_token}.#{file.extension}" if original_filename.present?
	end

	# Override the directory where uploaded files will be stored.
	# This is a sensible default for uploaders that are meant to be mounted:
	def cache_dir
		"#{Rails.root}/tmp/uploads"
	end
	
	def store_dir
		"uploads/tmp"
	end

	# Provide a default URL as a default if there hasn't been a file uploaded:
	def default_url
	#   # For Rails 3.1+ asset pipeline compatibility:
		ActionController::Base.helpers.image_path([version_name, "default.png"].compact.join('_'))
		# "/images/fallback/" + [:thumb, "default.jpg"].compact.join('_')
	end

	version :thumb do
		process thumbnail: [{format: 'png', quality: 10, size: 400, strip: false, logger: Rails.logger}]
		def full_filename for_file
			png_name for_file, version_name
		end
	end

	def png_name for_file, version_name
		%Q{#{version_name}_#{for_file.chomp(File.extname(for_file))}.png}
	end

	#
	# def scale(width, height)
	#   # do something
	# end

	# Add a white list of extensions which are allowed to be uploaded.
	# For images you might use something like this:
	def extension_white_list
		%w(m4v)
	end

	# Override the filename of the uploaded files:
	# Avoid using model.id or version_name here, see uploader/store.rb for details.
	# def filename
	#   "something.jpg" if original_filename
	# end

	protected
		def secure_token
			var = :"@#{mounted_as}_secure_token"
			model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
		end

end