# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

	# Include RMagick or MiniMagick support:
	include CarrierWave::RMagick
	# include CarrierWave::MiniMagick

	# Choose what kind of storage to use for this uploader:
	# storage :file
	storage :fog

	# Override the directory where uploaded files will be stored.
	# This is a sensible default for uploaders that are meant to be mounted:
	def store_dir
"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
	end

	# Process files as they are uploaded:
	resize_to_fit(800, 800)
	#
	# def scale(width, height)
	#   # do something
	# end
	
	def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
		ActionController::Base.helpers.image_path( [version_name, "default.png"].compact.join('_'))
	end

	# Create different versions of your uploaded files:
	version :micro do
		process :crop
		resize_to_fill(40,40)
	end

	version :thumb do
		process :crop
		resize_to_fill(75,75)
	end

	version :small do
		process :crop
		resize_to_fill(160,160)
	end

	version :medium do
		process :crop
		resize_to_fill(260,260)
	end

	def crop
		resize_to_fit(800, 800)
		if model.crop_x.present?
			manipulate! do |img|
				x = model.crop_x.to_i
				y = model.crop_y.to_i
				w = model.crop_w.to_i
				h = model.crop_h.to_i
				img.crop!(x, y, w, h)
			end
		end
	end	

	# Add a white list of extensions which are allowed to be uploaded.
	# For images you might use something like this:
	def extension_white_list
		%w(jpg jpeg gif png)
	end

	# Override the filename of the uploaded files:
	# Avoid using model.id or version_name here, see uploader/store.rb for details.
	# def filename
	#   "something.jpg" if original_filename
	# end

	end
