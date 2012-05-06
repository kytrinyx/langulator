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

    def combine
      @translations = initialize_aggregate

      individual_translations.target_translations.each do |i18n|
        @translations[i18n.path] = insert(i18n.language, i18n.translations, @translations[i18n.path])
      end
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

    def initialize_aggregate
      dict = {}
      individual_translations.source_translations.each do |i18n|
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

    def individual_translations=(i18ns)
      @individual_translations = i18ns
    end

    def individual_translations
      unless @individual_translations
        i18ns = IndividualTranslations.new
        languages.each do |language|
          extracted = extract(language, translations)
          extracted.each do |path, values|
            i18ns << IndividualTranslation.new(:path => path, :base_filename => language, :translations => values)
          end
        end
        @individual_translations = i18ns
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
