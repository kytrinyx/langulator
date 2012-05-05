module Langulator
  class Aggregate

    class << self
      def from_file(filename, options)
        translations = YAML.load(File.read(filename))
        new(:aggregate_translations => translations.merge(options))
      end
    end

    attr_reader :aggregate, :languages
    def initialize(options = {})
      @aggregate = options[:aggregate_translations]
      @languages = options[:languages]
    end

    def individual_translations
      @individual_translations ||= separate
    end

    def extract(language, tangled)
      separated = {}
      tangled.keys.each do |key|
        values = tangled[key]
        if translations?(values)
          separated[key] = values[language]
        else
          separated[key] = extract(language, values)
        end
      end
      separated
    end

    def decompile
      individual_translations.each do |language, translations|
        translations.each do |path, translation|
          filename = "#{path}#{language}.yml"
          write filename, translation
        end
      end
    end

    private

    def translations?(values)
      !values.keys.select {|key| languages.include?(key) }.empty?
    end

    def write(filename, content)
      File.open(filename, 'w:utf-8') do |file|
        file.write content.to_yaml
      end
    end

    def separate
      separated = {}
      languages.each do |language|
        separated[language] = extract(language, aggregate)
      end
      separated
    end
  end
end
