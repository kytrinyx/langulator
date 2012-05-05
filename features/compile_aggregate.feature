Feature: Aggregate individual translation files

Combines any number of source translation files into a single file,
where all the translations for a single key are grouped for easy translation.

  @outfile
  Scenario: Compile aggregate
    Given a website in English, French, and Dutch
    And there is a translation file for English
    And there is an outdated translation file for French
    And there is no translation file for Dutch
    When the aggregate file is compiled
    Then the output file collects the translation keys for easy translation
