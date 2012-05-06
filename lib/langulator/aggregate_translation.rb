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

  end
end
