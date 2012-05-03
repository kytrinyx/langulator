# Langulator

Manage your i18n.

Or rather: compile it into a single managable file and give it to the translator, so you don't have to deal with it.

## Caveats

If you need something other than US-ASCII, you may want to consider using ruby 1.9.3.

In 1.9.2 (patch 290):

   S\xC3\xB8knadstekst

In 1.9.3:

    Søknadstekst

## Installation

Add this line to your application's Gemfile:

    gem 'langulator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install langulator

## Usage

Given that you've written the original translations in English and also need French and German versions, and that you have multiple paths that contain i18n yml files named per the convention `<iso-language-code>.yml`, then this will give you a single output file where each key is listed with the translations immediately below it.

If you have partial translations in the target languages, these will be included.

Any extraneous translations (i.e. keys that may have been in use previously but are no longer referenced in the original language) will be discarded.

Any missing translations will be given keys with an empty spot, ready for translation.

It handles arbitrarily deep nestings.

This first version doesn't handle yml files that are namespaced by the language, but I anticipate needing it very soon.

Also, this first version doesn't actually decompile the finished product. Come back tomorrow for that one.

e.g.

Input:

    # en.yml
    ---
    food:
      breakfast: Eggs
      lunch: Sandwich
      dinner:
        main_course: Steak
        desert: Chocolate pudding

    # fr.yml
    ---
    food:
      breakfast: Des oeufs
    thank_you: Merci

    # no de.yml file

    Langulator.write(:language => 'en', :alternates => ['fr', 'de'], :base_path => '**/i18n/', :to => '/tmp/translations.yml')

Outputs:

    food:
      breakfast:
        en: Eggs
        fr: Des oeufs
        de: 
      lunch:
        en: Sandwich
        fr: 
        de: 
      dinner:
        main_course:
          en: Steak
          fr: 
          de: 
        desert:
          en: Chocolate pudding
          fr: 
          de: 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
