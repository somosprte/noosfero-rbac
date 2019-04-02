Feature: manage roles
  As an environment admin
  I want to create and edit roles

  @selenium
  Scenario: create new role
    Given I am logged in as admin
    And I go to the environment control panel
    And I follow "User roles"
    Then I should not see "My new role"
    And I follow "Create a new role"
    And I fill in "Name" with "My new role"
    And I check "Manage/Publish content"
    And I follow "Create role"
    And I go to the environment control panel
    And I follow "User roles"
    Then I should see "My new role"

  @selenium
  Scenario: edit a role
    Given I am logged in as admin
    And I go to the environment control panel
    And I follow "User roles"
    Then I should not see "My new role"
    And I follow "Profile Administrator"
    And I follow "Edit"
    And I fill in "Name" with "My new role"
    And I follow "Save changes"
    And I go to the environment control panel
    And I follow "User roles"
    Then I should see "My new role"
    And I should not see "Profile Administrator"
