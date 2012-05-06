# encoding: utf-8

Given /a website in English, French, and Norwegian$/ do
end

Given /^there is a translation file for English$/ do
end

Given /^there is an outdated translation file for French$/ do
end

Given /^there is no translation file for Norwegian$/ do
end

Given /^there is an aggregate translation file$/ do
end

When /the aggregate file is compiled/ do
  Langulator.compile(:source_language => :en, :target_languages => [:fr, :no], :base_path => 'features/fixtures/**/', :to => AGGREGATE_FILE)
end

When /^the aggregate file is decompiled$/ do
  Langulator.decompile(:languages => [:english, :francais, :norsk], :from => INFILE)
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
  YAML.load(File.read(AGGREGATE_FILE)).should eq(expected)
end

Then /^the English translations should be complete$/ do
  expected = {"food"=>{"breakfast"=>"yoghurt", "lunch"=>"sandwich", "dinner"=>{"main_course"=>"steak", "side"=>"baked potato", "desert"=>"chocolate mousse"}}}
  english = YAML.load(File.read('features/fixtures/english.yml')).should eq(expected)

  expected = {"volume"=>{"sound"=>"loud", "liquid"=>"full", "hair"=>"because I'm worth it"}}
  nested_english = YAML.load(File.read('features/fixtures/lang/english.yml')).should eq(expected)
end

Then /^the French translations should be complete$/ do
  expected = {"food"=>{"breakfast"=>"yaourt", "lunch"=>"sandwich", "dinner"=>{"main_course"=>"biffteak", "side"=>"pomme de terre au four", "desert"=>"mousse au chocolat"}}}
  french = YAML.load(File.read('features/fixtures/francais.yml')).should eq(expected)

  expected = {"volume"=>{"sound"=>"haut", "liquid"=>"plein", "hair"=>"parce que je le vaux bien"}}
  nested_french = YAML.load(File.read('features/fixtures/lang/francais.yml')).should eq(expected)
end

Then /^the Norwegian translations should be complete$/ do
  expected = {"food"=>{"breakfast"=>"joggurt", "lunch"=>"smørbrød", "dinner"=>{"main_course"=>"steak", "side"=>"bakt potet", "desert"=>"sjokolademousse"}}}
  norwegian = YAML.load(File.read('features/fixtures/norsk.yml')).should eq(expected)

  expected = {"volume"=>{"sound"=>"høyt", "liquid"=>"fullt", "hair"=>"for det er jeg verdt"}}
  nested_norwegian = YAML.load(File.read('features/fixtures/lang/norsk.yml')).should eq(expected)
end

