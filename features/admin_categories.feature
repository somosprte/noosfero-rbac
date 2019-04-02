Feature: manage categories
  As an administrator
  I want to manage the categories

  Background:
    Given the following categories
      | name       | display_in_menu |
      | Food       | true            |
      | Book       | true            |
    And the following categories
      | parent  | name        | display_in_menu |
      | Food    | Vegetarian  | true            |
      | Food    | Steak       | true            |
    Given I am logged in as admin

  @selenium
  Scenario: admin user could access new category
    Given I follow "menu-dropdown"
    And I wait for 1 seconds
    And I follow "Administration"
    And I follow "Categories"
    And I follow "New category"
    Then I should be on /admin/categories/new

  @selenium
  Scenario: admin user could create a category
    Given I go to /admin/categories/new
    And I fill in "Name" with "Category 1"
    When I follow "Save"
    Then I should see "General categories"
    And I should see "Category 1"

  @selenium
  Scenario: admin user could see all the category tree
    Given I follow "menu-dropdown"
    And I wait for 1 seconds
    And I follow "Administration"
    And I follow "Categories"
    When I follow "Show"
    Then I should see "Vegetarian"
    And I should see "Steak"

  @selenium
  Scenario: admin user could hide the category tree
    Given I follow "menu-dropdown"
    And I wait for 1 seconds
    And I follow "Administration"
    And I follow "Categories"
    When I follow "Show"
    Then I should see "Vegetarian"
    And I should see "Steak"
    When I follow "Hide"
    Then I should not see "Vegetarian"
    And I should not see "Steak"

  @selenium
  Scenario: the show link is available just for categories with category tree
    Given the following category
      | parent  | name     | display_in_menu |
      | Steak   | Pig      | true            |
    And I follow "menu-dropdown"
    And I wait for 1 seconds
    And I follow "Administration"
    And I follow "Categories"
    Then I should see "Food"
    When I follow "Show/Hide subcategories"
    Then I should see "Vegetarian"
    And I should see "Steak"
    And I follow "Show/Hide subcategories"
    And I should not see "Steak"
    Then I should not see "Vegetarian"
