class StreamController < ApplicationController
	include ActionController::Live
	
	before_filter :release_connection
	
	def comments
		id = params[:id]

		response.headers["Content-Type"] = "text/event-stream"
		sse = SSE.new(response.stream, retry: 0, event: "comments.create.#{id}")

		logger.info "subscribing to comments.create.#{id}"
		redis = Redis.new
		redis.psubscribe("comments.create.*") do |on|
			on.pmessage do |pattern, event, data|
				logger.info "BLAH!! event is #{event}" if event =~ /comments.create.(#{id}{1}|0{1})/
				sse.write(data) if event =~ /comments.create.(#{id}{1}|0{1})/
			end
		end

		rescue IOError
			logger.info "IOError rescued, and stream closed"
		ensure
			logger.info "Both redis connection and event-stream closed"
			redis.quit
			sse.close

		render nothing: true
	end

	private
		def channel(id)
			"new_comment_#{id}"
		end
		
		def release_connection
			logger.debug "releasing connection to pg database..."
			ActiveRecord::Base.connection_pool.release_connection
		end
end