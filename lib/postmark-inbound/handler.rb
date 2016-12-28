module PINS

  class Handler

    # Call as often as necessary to add handlers, usually from the config file; each call creates a PINS::Handler object
    # @param name [Symbol] or a String
    def self.add(name)
      @catalog ||= {}
      if @catalog[name]
        PINS.logger.warn("Handler not added, duplicate name: #{name}")
        return nil
      end
      handler = Handler.new(name)
      yield handler if block_given?
      @catalog[name] = handler
      PINS.logger.info("Added handler: #{name}")
    end

    # @return [Hash] containing all the handlers
    def self.catalog
      return @catalog
    end

    # Run the handlers, typically called by the server
    # @param pin [Hash] from Postmark inbound webhook JSON
    def self.run(pin, names = Handler.catalog.keys)
      PINS.logger.info('Running handlers...')
      names.each do |name|
        (Handler.catalog)[name].run(pin)
      end
      PINS.logger.info('Done running handlers.')
    end

    attr_reader :myname

    def initialize(name)
      PINS.logger.debug("Initializing handler: #{name}")
      @myname = name
    end

    # When adding a handler, call this to register a block
    def set_block(&block)
      PINS.logger.debug("Registering block for handler: #{myname}")
      @block = block
    end

    def run(obj)
      PINS.logger.warn("No block to execute for handler: #{myname}") unless @block
      PINS.logger.debug("Running handler: #{myname}")
      @block.call(obj)
    end

  end

end
