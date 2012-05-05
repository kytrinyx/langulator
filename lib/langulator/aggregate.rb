module Langulator
  class Aggregate

    class << self
      def from_file(filename, options)
        aggregate_translations = YAML.load(File.read(filename))
        new(aggregate_translations, options)
      end
    end

    attr_reader :aggregate, :languages
    def initialize(aggregate, options = {})
      @aggregate = aggregate
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

    private

    def translations?(values)
      !values.keys.select {|key| languages.include?(key) }.empty?
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
