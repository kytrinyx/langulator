$:.unshift "#{File.dirname(__FILE__)}/../../lib/"

require 'langulator'

path = 'features/fixtures/'

AGGREGATE_FILE = "#{path}out.yml"

INFILE = "#{path}in.yml"

individual = ['english', 'lang/english', 'francais', 'lang/francais', 'norsk', 'lang/norsk']
INDIVIDUAL_FILES = individual.map {|f| "#{path}#{f}.yml"}

