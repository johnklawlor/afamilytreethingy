AWS_CONFIG = YAML.load_file("#{::Rails.root}/config/aws.yml")[::Rails.env] if Rails.env==development

CarrierWave.configure do |config|
	config.fog_credentials = {
		provider: "AWS",
		aws_access_key_id: AWS_CONFIG["aws_key"] || ENV["aws_key"],
		aws_secret_access_key: AWS_CONFIG["aws_secret_key"] || ENV["aws_secret_key"]
	}
	config.fog_directory = AWS_CONFIG["aws_bucket"] || ENV["aws_bucket"]
	config.fog_public = false
end
