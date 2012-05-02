module Langulator
  class Loader

    attr_reader :base_path, :origin, :alternates
    def initialize(options = {})
      @base_path = options[:base_path]
      @origin = options[:origin]
      @alternates = options[:alternates]
    end

    def paths
      @paths ||= Dir.glob("#{base_path}#{origin}.yml").map {|file| file.gsub("#{origin}.yml", '') }.sort
    end

    def source_translations
      translations = load_translations(origin)
    end

    def destination_translations
      translations = {}
      alternates.each do |language|
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
