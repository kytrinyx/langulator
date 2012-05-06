require 'langulator/translation'
require 'langulator/individual_translation'
require 'translation_interface'

describe Langulator::IndividualTranslation do

  subject { Langulator::IndividualTranslation.new(:location => 'spec/fixtures/english.yml') }

  it_behaves_like "a translation"

  its(:language) { should eq(:english) }

end
