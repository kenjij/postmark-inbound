require 'postmark-inbound/handler'

module PINS

  class Config

    # Load Ruby config file
    # @param path [String] config file
    def self.load_config(path)
      raise 'config file missing' unless path
      PINS.logger.debug("Loading config file: #{path}")
      require File.expand_path(path)
      PINS.logger.info('Config.load_config done.')
    end

    # Returns the shared instance
    # @return [PINS::Config]
    def self.shared
      @shared_config ||= Config.new
    end

    # Call this from your config file
    def self.setup(&block)
      yield Config.shared
      PINS.logger.debug('Config.setup block executed.')
    end

    attr_accessor :user
    attr_accessor :auth_tokens
    attr_accessor :dump_errors
    attr_accessor :logging

    def initialize
      @auth_tokens = []
      @dump_errors = false
      @logging = false
    end

  end

end
