class StreamController < ApplicationController
	include ActionController::Live
	
	before_filter :release_connection
	
	def comments
		id = params[:id]

		response.headers["Content-Type"] = "text/event-stream"
		sse = SSE.new(response.stream, retry: 0, event: "comments.create")

		redis = Redis.new
		redis.subscribe('comments.create') do |on|
			on.message do |event, data|
				sse.write(data)
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