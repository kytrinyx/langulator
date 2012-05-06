require 'yaml'

module Langulator
  class Translation

    attr_reader :location
    def initialize(path_to_file = '', options = {})
      @location = path_to_file
      @translations = options[:translations]
    end

    def location=(s)
      @path = nil
      @filename = nil
      @location = s
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
