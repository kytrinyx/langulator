# encoding: utf-8
require 'yaml'
require 'langulator/aggregate'

module Langulator

  class << self
    def compile(options)
      Aggregate.from_files(options).compile
    end

    def decompile(options)
      Aggregate.from_file(options).decompile
    end
  end

end
