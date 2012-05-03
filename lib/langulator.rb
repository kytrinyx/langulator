# encoding: utf-8
require 'yaml'
require 'langulator/loader'
require 'langulator/munger'
require 'langulator/untangler'

module Langulator
  class << self
    def munge(options = {})
      loader = Loader.new(options)
      munger = Munger.new(:language => loader.origin, :translations => loader.source_translations, :alternates => loader.destination_translations)

      munger.munge
    end

    def compile(options)
      filename = options[:to]
      translations = compile(options)
      write filename, translations
    end

    def untangle(aggregate, options)
      Untangler.new(aggregate, options).untangle
    end

    def decompile(aggregate, options)
      translations = untangle(aggregate, options)

      translations.each do |language, data|
        data.each do |path, translation|
          filename = "#{path}#{language}.yml"
          write filename, translation
        end
      end
    end

    private
    def write(filename, content)
      File.open(filename, 'w:utf-8') do |file|
        file.write content.to_yaml
      end
    end
  end
end
