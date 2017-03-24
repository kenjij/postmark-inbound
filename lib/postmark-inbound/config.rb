module PINS

  def self.config
    Config.shared
  end

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
    def self.setup
      yield Config.shared
      PINS.logger.debug('Config.setup block executed.')
    end

    attr_accessor :user
    attr_accessor :passwords
    attr_accessor :handler_paths
    attr_accessor :dump_errors
    attr_accessor :logging

    def initialize
      @passwords = []
      @handler_paths = []
      @dump_errors = false
      @logging = false
    end

  end

end
