# Langulator

Manage your i18n.

Or rather: compile it into a single managable file and give it to the translator, so you don't have to deal with it.

For example, given that you've written the original translations in English and also need French and Norwegian versions, and that you have multiple paths that contain i18n yml files named per the convention `<iso-language-code>.yml` (don't get me started on the Norwegian iso language code), then this will give you a single output file where each key is listed with the translations immediately below it.

If you have partial translations in the target languages, these will be included.

Any extraneous translations (i.e. keys that may have been in use previously but are no longer referenced in the original language) will be discarded.

Any missing translations will be given keys with an empty spot, ready for translation.

It handles arbitrarily deep nestings.

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

### Compile

* `decompile` from an aggregate file (`separate` into final data structures), write to files

    load -> combine into aggregate -> write :to => file
    load :from => file -> separate from aggregate -> write

## Usage

### Compile

Compile from `.yml` files at given (wildcard) paths into an aggregate data structure, and write this to a file.

    Langulator.compile(:original => 'en', :alternates => ['fr', 'no'], :base_path => '**/i18n/', :to => '/tmp/translations.yml')

Input:

    # config/i18n/en.yml
    ---
    food:
      breakfast: Eggs
      lunch: Sandwich
      dinner:
        main_course: Steak
        desert: Chocolate mousse

    # config/i18n/fr.yml
    ---
    food:
      breakfast: Des oeufs
    thank_you: Merci

    # missing no.yml file

Outputs:

      # tmp/translations.yml
      config/i18n/:
        food:
          breakfast:
            en: Eggs
            fr: Des oeufs
            no: 
          lunch:
            en: Sandwich
            fr: 
            no: 
          dinner:
            main_course:
              en: Steak
              fr: 
              no: 
            desert:
              en: Chocolate pudding
              fr: 
              no: 


### Decompile

Decompile from a single aggregate `.yml` file, writing the separate translation files to their original locations.

    Langulator.decompile(:file => './tmp/translations.yml', :languages => ['en', 'fr', 'no'])

Input:

      config/i18n/:
        food:
          breakfast:
            en: Eggs
            fr: Des oeufs
            no: Egg
          lunch:
            en: Sandwich
            fr: Sandwich
            no: Ostesmørbrød
          dinner:
            main_course:
              en: Steak
              fr: Biffteak
              no: Steak
            desert:
              en: Chocolate mousse
              fr: Mousse au chocolat
              no: Sjokolademousse

Output:

    # config/i18n/en.yml
    ---
    food:
      breakfast: Eggs
      lunch: Sandwich
      dinner:
        main_course: Steak
        desert: Chocolate mousse

    # config/i18n/fr.yml
    ---
    food:
      breakfast: Des oeufs
      lunch: Sandwich
      dinner:
        main_course: Biffteak
        desert: Mousse au chocolat

    # config/i18n/no.yml
    ---
    food:
      breakfast: Egg
      lunch: Sandwich
      dinner:
        main_course: Steak
        desert: Sjokolademousse

## TODO

* refactor to use a core `Aggregate` class rather than the rather arbitrary classes currently in use.
* handle yml files that are namespaced by the language, e.g.
```
---
en:
  stuff: "whatever"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
