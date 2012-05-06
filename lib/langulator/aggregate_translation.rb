module Langulator
  class AggregateTranslation < Translation

    def languages
      @languages ||= detect_languages
    end

    def detect_languages(dictionary = translations, detected = [])
      dictionary.each do |key, values|
        if values.is_a?(Hash)
          detect_languages(values, detected)
        else
          language = key.to_sym
          # The languages are always listed together.
          # If we're seeing a duplicate language, then we're done
          return detected if detected.include?(language)

          detected << language
        end
      end
      return detected
    end

    def individual_translations
      unless @individual_translations
        collection = IndividualTranslations.new
        languages.each do |language|
          extracted = extract(language, translations)
          extracted.each do |path, values|
            collection << IndividualTranslation.new(:path => path, :base_filename => language, :translations => values)
          end
        end
        @individual_translations = collection
      end
      @individual_translations
    end

    def decompile
      individual_translations.each(&:write)
    end

    def extract(language, aggregate)
      separated = {}
      aggregate.keys.each do |key|
        values = aggregate[key]
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
