require 'sinatra/base'
require 'postmark-inbound/helper'

module PINS

  # The Sinatra server
  class Server < Sinatra::Base

    use Rack::Auth::Basic, "Restricted Area" do |_username, password|
      PINS.config.passwords.include?(password)
    end

    helpers Helper

    configure do
      set :environment, :production
      disable :static
      c = PINS.config
      set :dump_errors, c.dump_errors
      set :logging, c.logging
      PINS.logger.info('Sinatra server configured.')
    end

    post '/' do
      PINS.logger.info('Incoming request received.')
      PINS.logger.debug("Body size: #{request.content_length} bytes")
      request.body.rewind
      Handler.run_handlers(parse_json(request.body.read))
      body ''
    end

    not_found do
      PINS.logger.info('Invalid request.')
      PINS.logger.debug("Request method and path: #{request.request_method} #{request.path}")
      json_with_object({message: 'Huh, nothing here.'})
    end

    error do
      status 500
      err = env['sinatra.error']
      PINS.logger.error "#{err.class.name} - #{err}"
      json_with_object({message: 'Yikes, internal error.'})
    end

    after do
      content_type 'application/json'
    end

  end
end
