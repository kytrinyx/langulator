# encoding: utf-8
require 'yaml'
require 'langulator/loader'
require 'langulator/aggregate'

module Langulator
  class << self

    def compile(options)
      source_language = options[:source_language]
      target_languages = options[:target_languages]
      languages = target_languages + [source_language]

      loader = Loader.new(:languages => languages, :base_path => options[:base_path])

      aggregate_options = {
        :source_language => source_language,
        :target_languages => target_languages,
        :individual_translations => loader.translations
      }
      write options[:to], Aggregate.new(aggregate_options).aggregate
    end

    def decompile(options)
      Aggregate.from_file(options[:from], :languages => options[:languages]).decompile
    end

    private
    def write(filename, content)
      File.open(filename, 'w:utf-8') do |file|
        file.write content.to_yaml
      end
    end
  end
end
