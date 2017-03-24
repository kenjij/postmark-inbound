# postmark-inbound

[![Gem Version](https://badge.fury.io/rb/postmark-inbound.svg)](http://badge.fury.io/rb/postmark-inbound) [![Code Climate](https://codeclimate.com/github/kenjij/postmark-inbound/badges/gpa.svg)](https://codeclimate.com/github/kenjij/postmark-inbound) [![security](https://hakiri.io/github/kenjij/postmark-inbound/master.svg)](https://hakiri.io/github/kenjij/postmark-inbound/master)

A Ruby server for Postmark inbound webhook.

## Requirements

- [Ruby](https://www.ruby-lang.org/) 2.1 <=
- [Kajiki](https://kenjij.github.io/kajiki/) 1.1 <=
- [Sinatra](http://www.sinatrarb.com) 1.4 <=

## Install

```
$ gem install postmark-inbound
```

## Configure

Create a configuration file following the example below.

```ruby
# Configure application logging
PINS.logger = Logger.new(STDOUT)
PINS.logger.level = Logger::DEBUG

PINS::Config.setup do |c|
  # User custom data
  c.user = {my_data1: 'Something', my_data2: 'Somethingelse'}
  # For security, basic auth is required.
  # Set accepted passwords; username is ignored
  c.passwords = [
    'someSTRING1234',
    'OTHERstring987'
  ]
  # Paths of where you've stored the handlers
  c.handler_paths = [
    'handlers'
  ]
  # HTTP server (Sinatra) settings
  c.dump_errors = true
  c.logging = true
end
```

### Handlers

Handler blocks are called for every incoming requests. Create as many files you'd like containing handlers, for example: `handlers/examples.rb`

```ruby
PINS::Handler.add do |pin|
  # The 'pin' variable contains data from Postmark
  break unless pin[:originalrecipient] == 'myinbox@pm.example.com'
  puts "It's a match!"
  # Do something more
end

# You can have multiple handlers in one file
PINS::Handler.add do |pin|
  break unless pin[:spam_status]
  puts "We've got a spam."
  # Do something more
end

```

## Use

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
