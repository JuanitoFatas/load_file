# frozen_string_literal: true
require "load_file/version"
require "load_file/loader"

# Module to load file(s) into constant
module LoadFile
  # Loads file into constant.
  #
  # @param [String, Pathname, File] path to load the file from
  # @param [String, Symbol] constant name to load into
  # @param namespace [Object] namespace to find/load the constant, defaults to Object
  # @return [Hash] loaded file content
  # @return [NilClass] nil when file not exists
  def self.load(file:, constant:, namespace: Object)
    ignore_file_not_exists do
      loader = Loader.new(file, constant, namespace: namespace)
      loader.set_constant
    end
  end

  # Loads file into constant.
  #
  # @param [String, Pathname, File] path to load the file from
  # @param [String, Symbol] constant name to load into
  # @param namespace [Object] namespace to find/load the constant, defaults to Object
  # @return [Hash] loaded file content, raises an error when file not exists
  # @return [NilClass] nil when file not exists
  def self.load!(file:, constant:, namespace: Object)
    loader = Loader.new(file, constant, namespace: namespace)
    loader.set_constant
  end

  # Loads files into constant.
  # Any file not exists will be ignored and not raise error.
  #
  # @param [Array<String>] list of files to load
  # @param [String, Symbol] constant name to load into
  # @return [Hash] last loaded file content
  # @return [NilClass] nil when last file not exists
  def self.load_files(files:, constant:, namespace: Object)
    files.each { |file| load(file: file, constant: constant, namespace: namespace) }
  end

  # Loads files into constant.
  #
  # @param [Array<String>] list of files to load
  # @param [String, Symbol] constant name to load into
  # @return [Hash] last loaded file content, raises an error when any file not exists
  def self.load_files!(files:, constant:, namespace: Object)
    files.each { |file| load!(file: file, constant: constant, namespace: namespace) }
  end

  # Overload a `file` into `constant`.
  # Same as `load`, but will override existing values in `constant`.
  #
  # @param [String, Pathname, File] path to overload the file from
  # @param [String, Symbol] constant name to overload into
  # @return [Hash] overloaded file content
  # @return [NilClass] nil when file not exists
  def self.overload(file:, constant:, namespace: Object)
    ignore_file_not_exists do
      reader = Loader.new(file, constant, namespace: namespace)
      reader.set_constant!
    end
  end

  # Overload a `file` into `constant`.
  # Same as `load!`, but will override existing values in `constant`.
  #
  # @param [String, Pathname, File] path to overload the file from
  # @param [String, Symbol] constant name to overload into
  # @return [Hash] overloaded file content, raises an error when file not exists
  # @return [NilClass] nil when file not exists
  def self.overload!(file:, constant:, namespace: Object)
    reader = Loader.new(file, constant, namespace: namespace)
    reader.set_constant!
  end

  # Overload files into constant.
  # Any file not exists will be ignored and not raise error.
  # Same as `load_files`, but will override existing values in `constant`.
  #
  # @param [Array<String>] list of files to overload
  # @param [String, Symbol] constant name to overload into
  # @return [Hash] last overloaded file content
  # @return [NilClass] nil when last file not exists
  def self.overload_files(files:, constant:, namespace: Object)
    files.each { |file| overload(file: file, constant: constant, namespace: namespace) }
  end

  # Overload files into constant.
  # Any file not exists will raise error.
  # Same as `load_files!`, but will override existing values in `constant`.
  #
  # @param [Array<String>] list of files to overload
  # @param [String, Symbol] constant name to overload into
  # @return [Hash] last overloaded file content, raises an error when any file not exists
  def self.overload_files!(files:, constant:, namespace: Object)
    files.each { |file| overload!(file: file, constant: constant, namespace: namespace) }
  end

  # @private
  def self.ignore_file_not_exists
    yield
  rescue Errno::ENOENT
  end
end
