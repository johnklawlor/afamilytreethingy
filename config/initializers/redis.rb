# config/initializers/redis.rb

uri = URI.parse(ENV["REDISTOGO_URL"])
$redis = Redis.new(:url => ENV['REDISTOGO_URL'])

heartbeat_thread = Thread.new do
  while true
    $redis.publish("heartbeat","thump")
    sleep 15.seconds
  end
end

at_exit do
  # not sure this is needed, but just in case
  heartbeat_thread.kill
  $redis.quit
end