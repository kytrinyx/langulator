require 'yaml'

module Langulator
  class Translation

    attr_reader :location
    def initialize(options = {})
      @path = options[:path]
      if options[:base_filename]
        @filename = "#{options[:base_filename]}.yml"
      end
      @location = options[:location] || "#{@path}#{@filename}"
      @translations = options[:translations]
    end

    def path
      @path ||= location[/^(.*\/)/, 0] || "./"
    end

    def filename
      @filename ||= location.gsub(path, '')
    end

    def translations
      @translations ||= YAML.load(File.read(location))
    end

    def write
      File.open(location, 'w:utf-8') do |file|
        file.write translations.to_yaml
      end
    end

  end
end
