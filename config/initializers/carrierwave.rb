AWS_CONFIG = YAML.load_file("#{::Rails.root}/config/aws.yml")[::Rails.env] if Rails.env.development?

CarrierWave.configure do |config|
	config.fog_credentials = {
		provider: "AWS",
		aws_access_key_id: ENV["aws_key"] || AWS_CONFIG["aws_key"],
		aws_secret_access_key: ENV["aws_secret_key"] || AWS_CONFIG["aws_secret_key"]
	}
	config.fog_directory = ENV["aws_bucket"] || AWS_CONFIG["aws_bucket"]
	config.fog_public = false
end
