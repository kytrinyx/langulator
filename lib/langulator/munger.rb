module Langulator
  class Munger

    attr_reader :source_language, :source_translations, :alternate_translations
    def initialize(options = {})
      @source_language = options[:language]
      @source_translations = options[:translations]
      @alternate_translations = options[:alternates]
    end

    def munge
      dictionary = transform(source_language, source_translations)
      alternate_translations.each do |language, translations|
        dictionary = insert(language, translations, dictionary)
      end
      dictionary
    end

    def transform(language, translations)
      dictionary = {}
      translations.each do |key, value|
        dictionary[key] ||= {}
        if value.is_a?(Hash)
          dictionary[key] = transform(language, value)
        else
          dictionary[key][language] = value
        end
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

  end
end
