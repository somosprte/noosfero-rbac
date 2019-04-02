Feature: accept member
  As an admin user
  I want to accept a member request
  In order to join a community

  Background:
    Given the following users
      | login | name        |
      | mario | Mario Souto |
      | marie | Marie Curie |
    And the following community
      | identifier  | name         |
      | mycommunity | My Community |
    And the community "My Community" is closed
    And "Mario Souto" is admin of "My Community"

  Scenario: a user should see its merbership is pending
    Given I am logged in as "mario"
    And the following communities
      | owner | identifier        | name              | closed |
      | marie | private-community | Private Community | true   |
    And I go to private-community's homepage
    When I follow "Join this community"
    And I go to private-community's homepage
    Then I should see "Your membership is waiting for approval"

  @selenium-fixme
  Scenario: approve a task to accept a member as member in a closed community
    Given "Marie Curie" asked to join "My Community"
    And I am logged in as "mario"
    And I follow "menu-toggle"
    And I should see "Marie Curie wants to be a member of 'My Community'."
    When I follow "Tasks" within "#section-profile"
    And I choose "Accept" within "#task-1"
    And I check "Profile Member"
    And I follow "Save tasks"
    Then "Marie Curie" should be a member of "My Community"

  @selenium
  Scenario: approve a task to accept a member as admin in a closed community
    Given "Marie Curie" asked to join "My Community"
    And I am logged in as "mario"
    And I follow "menu-toggle"
    And I should see "Marie Curie wants to be a member of 'My Community'."
    When I follow "Tasks" within "#section-profile"
    And I choose "Accept" within "#task-1"
    And I check "Profile Administrator"
    And I follow "Save tasks"
    Then "Marie Curie" should be admin of "My Community"

  @selenium
  Scenario: approve a member as administrator in a closed community
    Given "Marie Curie" asked to join "My Community"
    And I am logged in as "mario"
    And I follow "menu-toggle"
    And I should see "Marie Curie wants to be a member of 'My Community'."
    When I follow "Tasks" within "#section-profile"
    And I choose "Accept" within "#task-1"
    And I wait 1 seconds
    And I check "Profile Member"
    And I follow "Save tasks"
    Given I am on /myprofile/mycommunity
    When I follow "Members" within "#section-relationships"
    And I fill in "Name or Email" with "Marie Curie"
    And I follow "Search" within ".filter_fields"
    And I should see "Marie Curie"
    And I follow "Edit"
    And I check "Administrator"
    And I follow "Save changes"
    Then "Marie Curie" should be admin of "My Community"

  @selenium-fixme
  Scenario: approve a task to accept a member as moderator in a closed community
    Given "Marie Curie" asked to join "My Community"
    And I am logged in as "mario"
    And I follow "menu-toggle"
    And I follow "Tasks" within "#section-profile"
    And I wait 1 seconds
    And I choose "Accept"
    And I wait 1 seconds
    And I check "Profile Moderator"
    And I follow "Save tasks"
    Then "Marie Curie" should be moderator of "My Community"

  @selenium
  Scenario: approve a member as moderator in a closed community
    Given "Marie Curie" asked to join "My Community"
    And I am logged in as "mario"
    And I follow "menu-toggle"
    And I should see "Marie Curie wants to be a member of 'My Community'."
    When I follow "Tasks" within "#section-profile"
    And I choose "Accept" within "#task-1"
    And I wait 1 seconds
    And I check "Profile Member"
    And I follow "Save tasks"
    Given I am on /myprofile/mycommunity
    When I follow "Members" within "#section-relationships"
    And I fill in "Name or Email" with "Marie Curie"
    And I follow "Search" within ".filter_fields"
    And I should see "Marie Curie"
    And I follow "Edit"
    And I check "Moderator"
    And I follow "Save changes"
    Then "Marie Curie" should be moderator of "My Community"
