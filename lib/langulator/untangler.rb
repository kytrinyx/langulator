module Langulator
  class Untangler
    attr_reader :aggregate, :languages
    def initialize(aggregate, options = {})
      @aggregate = aggregate
      @languages = options[:languages]
    end

    def untangle
      untangled = {}
      languages.each do |language|
        untangled[language] = extract(language, aggregate)
      end
      untangled
    end

    def extract(language, tangled)
      untangled = {}
      tangled.keys.each do |key|
        values = tangled[key]
        if translations?(values)
          untangled[key] = values[language]
        else
          untangled[key] = extract(language, values)
        end
      end
      untangled
    end

    def translations?(values)
      !values.keys.select {|key| languages.include?(key) }.empty?
    end
  end
end
