# encoding: utf-8

Given /a website in English, French, and Norwegian$/ do
end

Given /^there is a translation file for English$/ do
end

Given /^there is an outdated translation file for French$/ do
end

Given /^there is no translation file for Norwegian$/ do
end

When /the aggregate file is compiled/ do
  Langulator.compile(:source_language => :en, :target_languages => [:fr, :no], :base_path => 'features/fixtures/**/', :to => OUTFILE)
end

Then /^the output file collects the translation keys for easy translation$/ do
  expected = {
    "features/fixtures/" => {
      "food" => {
        "breakfast" => {:en => "yoghurt", :no => nil, :fr => "yaourt"},
        "lunch" => {:en => "sandwich", :no => nil, :fr => "sandwich"},
        "dinner" => {
          "main_course" => {:en => "steak", :no => nil, :fr => "biffteak"},
          "side" => {:en => "baked potato", :no => nil, :fr => nil},
          "desert" => {:en => "chocolate mousse", :no => nil, :fr => "mousse au chocolat"}
        }
      }
    },
    "features/fixtures/lang/" => {
      "volume" => {
        "sound" => {:en => "loud", :no => nil, :fr => "haut"},
        "liquid" => {:en => "full", :no => nil, :fr => "plein"},
        "hair" => {:en => "because I'm worth it", :no => nil, :fr => "parce que je le vaux bien"}
      }
    }
  }
  YAML.load(File.read(OUTFILE)).should eq(expected)
end
