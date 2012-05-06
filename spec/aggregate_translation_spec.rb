require 'langulator/translation'
require 'langulator/aggregate_translation'
require 'langulator/individual_translation'
require 'langulator/individual_translations'
require 'translation_interface'

describe Langulator::AggregateTranslation do
  subject { Langulator::AggregateTranslation.new(:location => 'spec/fixtures/translations.yml') }

  it_behaves_like "a translation"

  its(:languages) { should eq([:klingon, :lolcode]) }

end
