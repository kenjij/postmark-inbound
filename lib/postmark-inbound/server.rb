require 'sinatra/base'
require 'postmark-inbound/helper'

module PINS

  # The Sinatra server
  class Server < Sinatra::Base

    helpers Helper

    configure do
      set :environment, :production
      disable :static
      c = Config.shared
      set :dump_errors, c.dump_errors
      set :logging, c.logging
      PINS.logger.info('Sinatra server configured.')
    end

    before do
      tokens = Config.shared.auth_tokens
      halt 401 unless tokens.empty? || tokens.include?(params[:auth])
    end

    post '/' do
      PINS.logger.info('Incoming request received.')
      PINS.logger.debug("Body size: #{request.content_length} bytes")
      request.body.rewind
      Handler.run(parse_json(request.body.read))
      body ''
    end

    not_found do
      PINS.logger.info('Invalid request.')
      PINS.logger.debug("Request method and path: #{request.request_method} #{request.path}")
      json_with_object({message: 'Huh, nothing here.'})
    end

    error 401 do
      PINS.logger.info(params[:auth] ? 'Invalid auth token provided.' : 'Missing auth token.')
      PINS.logger.debug("Provided auth token: #{params[:auth]}") if params[:auth]
      json_with_object({message: 'Oops, need a valid auth.'})
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
