require 'thor'

module Langulator

  class CLI < Thor

    desc "compile", "Combine individual i18n files into a single aggregate"
    method_option :source_language, :type => :string, :aliases => "-s", :required => true, :desc => "Which i18n files have the required keys? Expects i18n files to be in format <language>.yml"
    method_option :target_languages, :type => :array, :aliases => "-t", :required => true, :desc => "The target languages"
    method_option :base_path, :type => :string, :aliases => "-p", :default => '**/i18n/', :desc => "The path used to glob for .yml files matching the desired languages"
    method_option :file, :type => :string, :aliases => "-f", :default => './tmp/translations.yml', :desc => "The target path of the aggregate file"
    def compile
      compile_options = {
        :source_language => options[:source_language].to_sym,
        :target_languages => options[:target_languages].map(&:to_sym),
        :base_path => options[:base_path],
        :to => options[:file]
      }
      Langulator.compile(compile_options)
    end

    method_option :file, :type => :string, :aliases => "-f", :default => './tmp/translations.yml', :desc => "The path of the aggregate file"
    desc "decompile", "Split an aggregate into its respective i18n files"
    def decompile
      Langulator.decompile(:from => options[:file])
    end

  end
end

