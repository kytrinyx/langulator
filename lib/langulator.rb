# encoding: utf-8
require 'yaml'
require 'langulator/loader'
require 'langulator/munger'

module Langulator
  def self.compile(options = {})
    loader = Loader.new(options)
    munger = Munger.new(:language => loader.origin, :translations => loader.source_translations, :alternates => loader.destination_translations)

    munger.munge
  end

  def self.write(options)
    translations = compile(options)
    File.open(options[:to], 'w:utf-8') do |file|
      file.write translations.to_yaml
    end
  end
end
