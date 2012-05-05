# encoding: utf-8
require 'yaml'
require 'langulator/loader'

describe Langulator::Loader do

  let(:english) do
    {
      "spec/fixtures/" => {
        "food" => {
          "breakfast" => "yoghurt",
          "lunch" => "sandwich",
          "dinner" => {"main_course" => "steak", "side" => "baked potato", "desert" => "chocolate mousse"}
        }
      },
      "spec/fixtures/lang/" => {
        "volume" => {
          "sound" => "loud",
          "liquid" => "sloshing",
          "hair" => "because I'm worth it"
        }
      }
    }
  end

  let(:norwegian) do
    {
      "spec/fixtures/" => {
        "food" => {
          "lunch" => "smørbrød"
        }
      },
      "spec/fixtures/lang/" => {}
    }
  end

  let(:french) do
    {
      "spec/fixtures/" => {},
      "spec/fixtures/lang/" => {}
    }
  end

  subject { Langulator::Loader.new(:base_path => 'spec/fixtures/**/', :source_language => 'english', :target_languages => ['norsk', 'francais']) }
  its(:translations) { should eq({'english' => english, 'norsk' => norwegian, 'francais' => french}) }
end
