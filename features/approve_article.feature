Feature: approve article
  As a community admin
  I want to approve an article
  In order to share it with other users

  Background:
    Given the following users
      | login      | name        | email                  |
      | joaosilva  | Joao Silva  | joaosilva@example.com  |
      | mariasilva | Maria Silva | mariasilva@example.com |
    And the following articles
      | owner | name | body | homepage |
      | mariasilva | Sample Article | This is an article | true |
      | mariasilva | Dub Wars | This is an article | false |
    And the following communities
      | identifier | name |
      | sample-community | Sample Community |
    And the articles of "Sample Community" are moderated
    And "Maria Silva" is a member of "Sample Community"
    And "Joao Silva" is admin of "Sample Community"

  #FIXME this test is possibly failing because of this issue https://gitlab.com/pedrodelyra/noosfero/issues/8
  @selenium-fixme
  Scenario: edit an article before approval
    Given I am logged in as "mariasilva"
    And I am on mariasilva's homepage
    When I follow "Spread"
    And I check "Sample Community"
    And I follow "Spread this"
    And I am logged in as "joaosilva"
    And I go to sample-community's control panel
    And I follow "Process requests"
    And I fill in "Text" with "This is an article edited"
    And I choose "Accept"
    And I follow "Apply!"
    And I go to sample-community's sitemap
    And I follow "Sample Article"
    Then I should see "This is an article edited"

  @selenium-fixme
  Scenario: reject an article with explanation
    Given I am logged in as "mariasilva"
    And I go to mariasilva's cms
    And I follow "Sample Article"
    And I follow "article-options"
    And I follow "Spread"
    And I type in "Sample Community" into autocomplete list "search-communities-to-publish" and I choose "Sample Community"
    And I follow "Spread this"
    And I am logged in as "joaosilva"
    And I go to sample-community's control panel
    And I follow "Tasks"
    And I choose "Reject"
    And I fill in "tasks_1_task_reject_explanation" with "Rejected"
    And I follow "Save tasks"
    When I go to sample-community's sitemap
    Then I should not see "Sample Article"

  #FIXME this test is possibly failing because of this issue https://gitlab.com/pedrodelyra/noosfero/issues/2
  @selenium-fixme
  Scenario: reject an article that was removed
    Given I am logged in as "mariasilva"
    And I follow "Dub Wars"
    And I follow "article-options"
    And I follow "Spread"
    And I type in "Sample Community" into autocomplete list "search-communities-to-publish" and I choose "Sample Community"
    And I follow "Spread this"
    And I follow "article-options"
    And I follow "Delete"
    And I confirm the browser dialog
    And I follow "menu-dropdown"
    And I follow "Logout"
    And I am logged in as "joaosilva"
    And I go to sample-community's control panel
    And I follow "Tasks"
    And I choose "Reject"
    And I fill in "tasks_1_task_reject_explanation" with "Article was removed."
    And I follow "Save tasks"
    Then I should see "No pending tasks"
    And I should not see "You have a nil object when you didn't expect it"
