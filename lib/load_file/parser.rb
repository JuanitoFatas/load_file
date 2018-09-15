# frozen_string_literal: true
require "yaml"
require "json"

module LoadFile
  class Parser
    ParserError = Class.new(StandardError)

    def self.yaml(content)
      if present?(content)
        YAML.safe_load(content, [Regexp, Symbol])
      else
        {}
      end
    rescue Psych::SyntaxError
      raise ParserError
    end

    def self.json(content)
      if present?(content)
        JSON.parse(content)
      else
        {}
      end
    rescue JSON::ParserError
      raise ParserError
    end

    def self.present?(string)
      string && !string.empty?
    end
  end
end
