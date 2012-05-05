# encoding: utf-8
require 'yaml'
require 'langulator/loader'
require 'langulator/munger'
require 'langulator/aggregate'

module Langulator
  class << self
    def munge(options = {})
      loader = Loader.new(options)
      munger = Munger.new(:language => loader.origin, :translations => loader.source_translations, :alternates => loader.destination_translations)

      munger.munge
    end

    def compile(options)
      filename = options[:to]
      translations = munge(options)
      write filename, translations
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
