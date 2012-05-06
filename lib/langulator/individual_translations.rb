module Langulator
  class IndividualTranslations
    include Enumerable

    attr_reader :translations, :aggregate_location, :base_path, :source_language, :target_languages
    def initialize(options = {})
      @aggregate_location = options[:to]
      @base_path = options[:base_path]
      @source_language = options[:source_language]
      @target_languages = options[:target_languages]
    end

    def each
      translations.each { |translation| yield translation }
    end

    def compile
      aggregate.write
    end

    def <<(*objects)
      @translations ||= []
      objects.flatten.each do |obj|
        translations << obj
      end
    end

    def in(*languages)
      select {|translation| languages.include?(translation.language)}
    end

    def source_translations
      return [] unless source_language

      self.in(source_language)
    end

    def target_translations
      return [] unless target_languages

      self.in(*target_languages)
    end

    def translations
      @translations ||= load_translations
    end

    def aggregate
      @aggregate ||= combine
    end

    private

    def load_translations
      i18ns = []
      [source_language, *target_languages].each do |language|
        paths.each do |path|
          i18ns << IndividualTranslation.new(:path => path, :base_filename => language)
        end
      end
      i18ns
    end

    def paths
      @paths ||= locations.map {|location| location.gsub("#{source_language}.yml", '')}
    end

    def locations
      @locations ||= Dir.glob("#{base_path}#{source_language}.yml")
    end

    def combine
      dictionary = initialize_aggregate

      target_translations.each do |i18n|
        dictionary[i18n.path] = insert(i18n.language, i18n.translations, dictionary[i18n.path])
      end

      AggregateTranslation.new(:location => aggregate_location, :translations => dictionary)
    end

    def initialize_aggregate
      dict = {}
      source_translations.each do |i18n|
        dict[i18n.path] = remap(i18n.language, i18n.translations)
      end
      dict
    end

    def remap(language, source)
      target = {}
      source.each do |key, value|
        target[key] ||= {}
        if value.is_a?(Hash)
          target[key] = remap(language, value)
        else
          target[key][language] = value
        end
      end
      target
    end

    def insert(language, source, target)
      target.dup.each do |key, value|
        if value.is_a?(Hash)
          insert(language, (source || {})[key], value)
        else
          target[language] = source
        end
      end
      target
    end

  end
end
