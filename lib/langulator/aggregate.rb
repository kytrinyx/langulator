module Langulator
  class Aggregate
    attr_reader :aggregate, :languages
    def initialize(aggregate, options = {})
      @aggregate = aggregate
      @languages = options[:languages]
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
  end
end
