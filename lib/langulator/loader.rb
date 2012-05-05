module Langulator
  class Loader

    attr_reader :base_path, :languages
    def initialize(options = {})
      @base_path = options[:base_path]
      @languages = [options[:source_language]] + options[:target_languages]
    end

    def paths
      unless @paths
        filename = "#{languages.first}.yml"
        @paths = Dir.glob("#{base_path}#{filename}").map {|file| file.gsub(filename, '') }.sort
      end
      @paths
    end

    def translations
      translations = {}
      languages.each do |language|
        translations[language] = load_translations(language)
      end
      translations
    end

    def load_translations(language)
      translations = {}
      paths.each do |path|
        translations[path] = read_translations(path, language)
      end
      translations
    end

    def read_translations(path, language)
      file = "#{path}#{language}.yml"
      if File.exists?(file)
        YAML.load(File.read(file))
      else
        {}
      end
    end

  end
end
