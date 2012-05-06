Feature: Separate an aggregate into individual i18n files

Takes an aggregate translation file and writes the translated keys into
their respective i18n files at their original locations.

  @decompile
  Scenario: Decompile aggregate
    Given a website in English, French, and Norwegian
    And there is an aggregate translation file
    When the aggregate file is decompiled
    Then the English translations should be complete
    And the French translations should be complete
    And the Norwegian translations should be complete
