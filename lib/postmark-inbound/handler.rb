module PINS

  def self.handlers
    Handler.handlers
  end

  class Handler

    # Load handlers from directories designated in config
    def self.autoload
      PINS.config.handler_paths.each { |path|
        load_from_path(path)
      }
    end

    # Load handlers from a directory
    # @param path [String] directory name
    def self.load_from_path(path)
      Dir.chdir(path) {
        Dir.foreach('.') { |f| load f unless File.directory?(f) }
      }
    end

    # Call as often as necessary to add handlers; each call creates a PINS::Handler object
    def self.add(&block)
      @handlers ||= []
      @handlers << Handler.new(&block)
      PINS.logger.debug("Added handler: #{@handlers.last}")
    end

    # @return [Array] containing all the handlers
    def self.handlers
      @handlers
    end

    # Run the handlers, typically called by the server
    # @param pin [Hash] from Postmark inbound webhook JSON
    def self.run_handlers(pin)
      PINS.logger.info('Running handlers...')
      @handlers.each { |h| h.run(pin) }
      PINS.logger.info('Done running handlers.')
    end

    def initialize(&block)
      @block = block
    end

    def run(obj)
      PINS.logger.warn("No block to execute for handler: #{self}") unless @block
      PINS.logger.debug("Running handler: #{self}")
      @block.call(obj)
    end

  end

end
