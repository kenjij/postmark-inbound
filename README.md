# postmark-inbound

[![Gem Version](https://badge.fury.io/rb/postmark-inbound.svg)](http://badge.fury.io/rb/postmark-inbound) [![Code Climate](https://codeclimate.com/github/kenjij/postmark-inbound/badges/gpa.svg)](https://codeclimate.com/github/kenjij/postmark-inbound) [![security](https://hakiri.io/github/kenjij/postmark-inbound/master.svg)](https://hakiri.io/github/kenjij/postmark-inbound/master)

A Ruby server for Postmark inbound webhook.

## Requirements

- Ruby 2.1 <=
- Kajiki 1.1 <=
- Sinatra 1.4 <=

## Getting Started

### Install

```
$ gem install postmark-inbound
```

### Configure

Create a configuration file following the example below.

```ruby
# Configure application logging
PINS.logger = Logger.new(STDOUT)
PINS.logger.level = Logger::DEBUG

PINS::Config.setup do |c|
  # User custom data
  c.user = {my_data1: 'Something', my_data2: 'Somethingelse'}
  # If any number of strings are set, it will require a matching "?auth=" parameter in the incoming request
  c.auth_tokens = [
    'adc9c81e23cd4ed785038028e69f7c54',
    '4e1bca06d99f477f89c110e12e45f8f4'
  ]
  # HTTP server (Sinatra) settings
  c.dump_errors = true
  c.logging = true
end

# Add and register handler blocks; all handlers will be called for every incoming request
PINS::Handler.add(:my_handler1) do |h|
  h.set_block do |pin|
    break unless pin[:originalrecipient] == 'myinbox@pm.example.com'
    puts "It's a match!"
    # Do something more
  end
end

PINS::Handler.add(:my_handler2) do |h|
  h.set_block do |pin|
    break unless pin[:spam_status]
    puts "We've got a spam."
    # Do something more
  end
end
```

### Use

To see help:

```
$ pin-server -h
Usage: pin-server [options] {start|stop}
  -c, --config=<s>     Load config from file
  -d, --daemonize      Run in the background
  -l, --log=<s>        Log output to file
  -P, --pid=<s>        Store PID to file
  -p, --port=<i>       Use port (default: 4567)
```

The minimum to start a server:

```
$ pin-server -c config.rb start
```
