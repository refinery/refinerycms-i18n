@refinerycms @i18n
Feature: Translation Support using i18n
  In order to have translation support using i18n
  As an administrator
  I want to use the dashboard

  Background:
    Given I am a logged in refinery user
    And my locale is en
    When I go to the Dashboard

  @i18n
  Scenario: Translation options available
    Then I should see "English Change language"

  @i18n
  Scenario: Change Language to Slovenian and back to English
    When I follow "English Change language"
    And I follow "Slovenian"
    Then I should be on the Dashboard
    And I should see "Slovenian Spremeni Jezik"
    And I should not see "Switch to your website"
    # Back to English
    When I follow "Slovenian Spremeni Jezik"
    And I follow "English"
    Then I should be on the Dashboard
    And I should see "Switch to your website"
    And I should not see "Spremeni Jezik"