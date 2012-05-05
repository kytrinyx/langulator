require 'langulator/loader'

module Langulator
  class Aggregate

    class << self
      def from_aggregate_file(options)
        translations = YAML.load(File.read(options[:from]))
        new options.merge(:aggregate_translations => translations)
      end

      def from_individual_files(options)
        loader = Loader.new(options)
        new options.merge(:individual_translations => loader.translations)
      end
    end

    attr_reader :languages, :source_language, :target_languages, :aggregate_file_path
    def initialize(options = {})
      @aggregate_file_path = options[:to]
      @aggregate = options[:aggregate_translations]
      @individual_translations = options[:individual_translations]
      @source_language = options[:source_language]
      @target_languages = Array(options[:target_languages])
      @languages = options[:languages] || [source_language] + target_languages
    end

    def compile
      write(aggregate_file_path, aggregate)
    end

    def aggregate
      @aggregate ||= combine
    end

    def combine
      source_translations = individual_translations[source_language]

      target_translations = {}
      target_languages.each do |language|
        target_translations[language] = individual_translations[language]
      end

      dictionary = to_aggregate(source_language, source_translations)
      target_translations.each do |language, translations|
        dictionary = insert(language, translations, dictionary)
      end

      dictionary
    end

    def insert(language, translations, dictionary)
      dictionary.dup.each do |key, value|
        if value.is_a?(Hash)
          insert(language, (translations || {})[key], value)
        else
          dictionary[language] = translations
        end
      end
      dictionary
    end

    # TODO: find a good name for this
    def to_aggregate(language, translations)
      dictionary = {}
      translations.each do |key, value|
        dictionary[key] ||= {}
        if value.is_a?(Hash)
          dictionary[key] = to_aggregate(language, value)
        else
          dictionary[key][language] = value
        end
      end
      dictionary
    end

    def decompile
      individual_translations.each do |language, translations|
        translations.each do |path, translation|
          filename = "#{path}#{language}.yml"
          write filename, translation
        end
      end
    end

    def individual_translations
      @individual_translations ||= separate
    end

    def separate
      separated = {}
      languages.each do |language|
        separated[language] = extract(language, aggregate)
      end
      separated
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

    def translations?(values)
      !values.keys.select {|key| languages.include?(key) }.empty?
    end

    def write(filename, content)
      File.open(filename, 'w:utf-8') do |file|
        file.write content.to_yaml
      end
    end

  end
end
