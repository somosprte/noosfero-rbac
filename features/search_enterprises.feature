Feature: search enterprises
  As a noosfero user
  I want to search enterprises
  In order to find ones that interest me

  @selenium
  Scenario: show empty search results
    Given the following enterprises
      | identifier | name        |
      | shop1      | Shoes shop  |
      | shop2      | Fruits shop |

    And I go to the search enterprises page
    And I fill in "search-input" with "something unrelated"
    And I follow "Search" within ".search-form"
    Then I should see "None" within ".search-results-type-empty"

  @selenium-fixme
  Scenario: simple search for enterprise
    Given the following enterprises
      | identifier | name        | img    |
      | shop1      | Shoes shop  | shoes  |
      | shop2      | Fruits shop | fruits |
    When I go to the search enterprises page
    And I fill in "search-input" with "shoes"
    And I follow "Search" within ".search-form"
    Then I should see "Shoes shop" within ".only-one-result-box"
    And I should see Shoes shop's profile image
    And I should not see "Fruits shop"
    And I should not see Fruits shop's profile image

  @selenium
  Scenario: show clean enterprise homepage on search results
    Given the following enterprises
      | identifier | name        |
      | shop1      | Shoes shop  |
    And the following articles
      | owner | name | body | homepage |
      | shop1 | Shoes home | This is the <i>homepage</i> of Shoes shop! It has a very long and pretty vague description, just so we can test wether the system will correctly create an excerpt of this text. We should probably talk about shoes. | true |
    When I go to the search enterprises page
    And I fill in "search-input" with "shoes"
    And I follow "Search" within ".search-form"
    And I wait for 1 seconds
    And I select "Full" from "display"
    Then I should see "This is the homepage of"
    And I should see "about sho..."

  @selenium-fixme
  Scenario: show clean enterprise description on search results
    Given the following enterprises
      | identifier | name | description |
      | shop4 | Clothes shop | This <b>clothes</b> shop also sells shoes! This too has a very long and pretty vague description, just so we can test wether the system will correctly create an excerpt of this text. Clothes are a really important part of our lives. |
    When I go to the search enterprises page
    And I fill in "search-input" with "clothes"
    And I follow "Search" within ".search-form"
    And I select "Full" from "display"
    And I should see "This clothes shop" within ".search-enterprise-description"
    And I should see "really import..." within ".search-enterprise-description"

  @selenium
  Scenario: find enterprises without exact query
    Given the following enterprises
      | identifier | name                            |
      | noosfero   | Noosfero Developers Association |
    When I go to the search enterprises page
    And I fill in "search-input" with "Noosfero Developers"
    And I follow "Search" within ".search-form"
    And I wait for 1 seconds
    Then I should see "Noosfero Developers Association" within "#search-results"
