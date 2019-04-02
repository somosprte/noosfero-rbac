Feature: private profiles
  As a profile administrator
  I want to set it to private
  So that only members/friends can view its contents

  Background:
    Given the following community
      | identifier | name     | access |
      | safernet   | Safernet |   30   |
    And the following users
      | login   | access |
      | joao    |    0   |
      | shygirl |   30   |

  Scenario: joining a private community
    Given I am logged in as "joao"
    When I go to safernet's homepage
    Then I should see "members only"
    When I follow "Join"
    And "joao" is accepted on community "Safernet"
    Then "joao" should be a member of "Safernet"
    When I go to Safernet's homepage
    And I should not see "members only"

  Scenario: adding a friend with private profile
    Given I am logged in as "joao"
    When I go to shygirl's homepage
    Then I should see "friends only"
    And I follow "Add friend"
    When I go to shygirl's homepage
    Then I should not see "Add friend"

  Scenario: person private profiles should not display sensible information
    Given I am logged in as "joao"
    When I go to shygirl's homepage
    Then I should not see "Basic information"
    Then I should not see "Work"
    Then I should not see "Enterprises"
    Then I should not see "Network"

  Scenario: community private profiles should not display sensible information
    Given I am logged in as "joao"
    When I go to Safernet's homepage
    Then I should not see "Basic information"
