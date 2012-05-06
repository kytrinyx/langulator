require 'langulator/translation'
require 'langulator/aggregate_translation'
require 'langulator/individual_translation'
require 'langulator/individual_translations'
require 'translation_interface'

describe Langulator::AggregateTranslation do
  subject { Langulator::AggregateTranslation.new(:location => 'spec/fixtures/translations.yml') }

  it_behaves_like "a translation"

  its(:languages) { should eq([:klingon, :lolcode]) }

  let(:combined) do
    {
      "spec/fixtures/" => {
        "words" => {
          "affirmative" => {
            :klingon => "HISlaH",
            :lolcode => "YA RLY"
          },
          "negative" => {
            :klingon => "ghobe'",
            :lolcode => "NO WAI"
          },
          "hello" => {
            :klingon => "nuqneH",
            :lolcode => "O HAI"
          }
        }
      }
    }
  end

  let(:klingon) do
    dictionary = {"words" => {"affirmative" => "HISlaH", "negative" => "ghobe'", "hello" => "nuqneH"}}
    Langulator::IndividualTranslation.new(:location => "spec/fixtures/klingon.yml", :translations => dictionary)
  end

  let(:lolcode) do
    dictionary = {"words" => {"affirmative" => "YA RLY", "negative" => "NO WAI", "hello" => "O HAI"}}
    Langulator::IndividualTranslation.new(:location => "spec/fixtures/lolcode.yml", :translations => dictionary)
  end

  it "combines" do
    translations = Langulator::IndividualTranslations.new(:source_language => :klingon, :target_languages => [:lolcode])
    translations << klingon
    translations << lolcode

    aggregate = Langulator::AggregateTranslation.new
    aggregate.individual_translations = translations
    aggregate.combine
    aggregate.translations.should eq(combined)
  end



end
