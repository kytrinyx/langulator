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
      unless @translations
        @translations = []
        [source_language, *target_languages].each do |language|
          paths.each do |path|
            @translations << IndividualTranslation.new(:path => path, :base_filename => language)
          end
        end
      end
      @translations
    end

    def aggregate
      unless @aggregate
        @aggregate = AggregateTranslation.new(:location => aggregate_location)
        @aggregate.individual_translations = self
        @aggregate.combine
      end
      @aggregate
    end

    def compile
      aggregate.write
    end

    def locations
      @locations ||= Dir.glob("#{base_path}#{source_language}.yml")
    end

    def paths
      @paths ||= locations.map {|location| location.gsub("#{source_language}.yml", '')}
    end

    def <<(obj)
      @translations ||= []
      translations << obj
    end
  end
end
