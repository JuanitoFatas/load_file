# frozen_string_literal: true
require_relative "parser"

module LoadFile
  # A class to load `file` into Hash, find or create constant by `constant_name`.
  #
  # @return [Hash] parsed YAML or JSON content
  class Loader < Hash
    def initialize(file, constant_name)
      @file = file
      @constant = find_or_define(constant_name)

      update parsed_content
    end

    # Set `values` into `constant` if not exists.
    def set_constant
      each { |key, value| constant[key] ||= value }
    end

    # Override `values` into `constant`.
    def set_constant!
      each { |key, value| constant[key] = value }
    end

    private

    attr_reader :file, :constant

    def find_or_define(constant_name)
      if Object.const_defined?(constant_name)
        Object.const_get(constant_name)
      else
        Object.const_set(constant_name, {})
      end
    end

    def parsed_content
      case File.extname(file)
      when ".yml", ".yaml"
        Parser.yaml(content)
      when ".json"
        Parser.json(content)
      else
        raise_parser_error("don't know how to parse #{file}")
      end
    rescue Parser::ParserError
      raise_parser_error("#{file} format is invalid")
    end

    def raise_parser_error(message)
      raise Parser::ParserError, message
    end

    def content
      IO.read(file)
    end
  end
end
