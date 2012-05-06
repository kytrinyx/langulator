module Langulator
  class IndividualTranslations
    include Enumerable

    attr_reader :translations
    def initialize
      @translations = []
    end

    def each
      translations.each { |translation| yield translation }
    end

    def <<(obj)
      translations << obj
    end
  end
end
