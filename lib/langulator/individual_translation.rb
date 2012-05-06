module Langulator
  class IndividualTranslation < Translation

    def language
      @language ||= filename.gsub(".yml", '').to_sym
    end
  end
end
