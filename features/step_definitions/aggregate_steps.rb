# encoding: utf-8

Given /a website in English, French, and Dutch$/ do
end

Given /^there is a translation file for English$/ do
end

Given /^there is an outdated translation file for French$/ do
end

Given /^there is no translation file for Dutch$/ do
end

When /the aggregate file is compiled/ do
  Langulator.compile(:source_language => :en, :target_languages => [:fr, :nl], :base_path => 'features/fixtures/**/', :to => OUTFILE)
end

Then /^the output file collects the translation keys for easy translation$/ do
  expected = {
    "features/fixtures/" => {
      "food" => {
        "breakfast" => {:en => "yoghurt", :nl => nil, :fr => "yaourt"},
        "lunch" => {:en => "sandwich", :nl => nil, :fr => "sandwich"},
        "dinner" => {
          "main_course" => {:en => "steak", :nl => nil, :fr => "biffteak"},
          "side" => {:en => "baked potato", :nl => nil, :fr => nil},
          "desert" => {:en => "chocolate mousse", :nl => nil, :fr => "mousse au chocolat"}
        }
      }
    },
    "features/fixtures/lang/" => {
      "volume" => {
        "sound" => {:en => "loud", :nl => nil, :fr => "haut"},
        "liquid" => {:en => "full", :nl => nil, :fr => "plein"},
        "hair" => {:en => "because I'm worth it", :nl => nil, :fr => "parce que je le vaux bien"}
      }
    }
  }
  YAML.load(File.read(OUTFILE)).should eq(expected)
end
