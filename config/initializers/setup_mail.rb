ActionMailer::Base.smtp_settings = {
	address:							'smtp.gmail.com',
	post:									587,
	domain:								'localhost:3000',
	user_name:						'myfamilypeeps@gmail.com',
	password:							'verysecretpassword',
	authentication:					'plain',
	enable_starttls_auto:			true
}