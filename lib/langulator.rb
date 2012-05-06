# encoding: utf-8
require 'yaml'
require 'langulator/aggregate'
require 'langulator/translation'
require 'langulator/aggregate_translation'
require 'langulator/individual_translation'
require 'langulator/individual_translations'

module Langulator

  class << self
    def compile(options)
      Aggregate.from_individual_files(options).compile
    end

    def decompile(options)
      AggregateTranslation.new(:location => options[:from]).decompile
    end
  end

end
