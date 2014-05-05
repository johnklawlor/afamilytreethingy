
heartbeat_thread = Thread.new do
	while true
		ActiveRecord::Base.connection.execute "NOTIFY heartbeat, #{ActiveRecord::Base.connection.quote 'thump'}"
		sleep 15.seconds
	end
end

at_exit do
  # not sure this is needed, but just in case
  heartbeat_thread.kill
end
