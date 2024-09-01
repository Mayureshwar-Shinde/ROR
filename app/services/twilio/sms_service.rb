require "twilio-ruby"

module Twilio
  class SmsService
  	TWILIO_ACCOUNT_SID = ''
  	TWILIO_AUTH_TOKEN = ''

  	def initialize
  	end

  	def call
  	  @client = Twilio::REST::Client.new(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
	    message = @client.messages.create(
			    body: "Hello from Ruby",
			    to: "+12086964143",
			    from: "+15005550006",
	      )
      puts message.sid
  	end

  	def case_sms(communication)
		  @client = Twilio::REST::Client.new(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
		  message_body = "Subject: #{communication.subject}\nFrom: #{communication.from.phone}\nMessage: #{communication.message}"
		  phone = communication.to.phone
		  message = @client.messages.create(
		    body: message_body,
		    to: "+12013514000",
		    from: "+15005550006",
		  )
		  puts "\n\n\n\n #{message.sid}"
		  puts "\n#{message_body}\n\n\n\n"
		end
  end
end
