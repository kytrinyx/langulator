module Langulator
  class AggregateTranslation < Translation

    attr_writer :individual_translations

    def languages
      @languages ||= detect_languages
    end

    def decompile
      individual_translations.each(&:write)
    end

    def individual_translations
      @individual_translations ||= extract_individual_translations
    end

    private

    def extract_individual_translations
      i18ns = IndividualTranslations.new
      languages.each do |language|
        i18ns << extract_translations(language)
      end
      i18ns
    end

    def extract_translations(language)
      extract(language, translations).map do |path, values|
        IndividualTranslation.new(:path => path, :base_filename => language, :translations => values)
      end
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
  end
end
