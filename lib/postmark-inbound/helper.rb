require 'json'
require 'time'

module PINS

  module Helper

    def parse_json(json)
      obj = JSON.parse(downcase_keys(json), {symbolize_names: true})
      return parse_pm(obj).merge!(catch_pm_headers(obj[:headers]))
    end

    # Convert JSON keys to lowercase
    # @param json [String]
    # @return [String] converted JSON
    def downcase_keys(json)
      json.gsub(/"\w+":/) { |m| m.downcase }
    end

    # Additional parsing/conversions
    def parse_pm(hash)
      hash[:date] = Time.parse(hash[:date]) if hash[:date]
      return hash
    end

    # Extract Postmark related headers into a Hash
    # @param headers [Array]
    # @return [Hash]
    def catch_pm_headers(headers)
      return {} unless Array === headers
      caught = {}
      headers.each do |h|
        case h[:name]
        when 'X-Spam-Status'
          caught[:spam_status] = h[:value].downcase.start_with?('yes')
        when 'X-Spam-Score'
          caught[:spam_score] = h[:value].to_f
        when 'Received-SPF'
          caught[:received_spf_status] = (h[:value].split)[0].downcase
        end
      end
      return caught
    end

    def lookup_email_headers(headers, name)
    end

    # Convert object into JSON, optionally pretty-format
    # @param obj [Object] any Ruby object
    # @param opts [Hash] any JSON options
    # @return [String] JSON string
    def json_with_object(obj, pretty: true, opts: nil)
      return '{}' if obj.nil?
      if pretty
        opts = {
          indent: '  ',
          space: ' ',
          object_nl: "\n",
          array_nl: "\n"
        }
      end
      JSON.fast_generate(json_format_value(obj), opts)
    end

    # Return Ruby object/value to JSON standard format
    # @param val [Object]
    # @return [Object]
    def json_format_value(val)
      case val
      when Array
        val.map { |v| json_format_value(v) }
      when Hash
        val.reduce({}) { |h, (k, v)| h.merge({k => json_format_value(v)}) }
      when String
        val.encode!('UTF-8', {invalid: :replace, undef: :replace})
      when Time
        val.utc.iso8601
      else
        val
      end
    end

  end

end
