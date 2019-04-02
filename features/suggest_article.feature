Feature: suggest article
  As a not logged user
  I want to suggest an article
  In order to share it with other users

  Background:
    Given the following users
      | login | name |
      | joaosilva | Joao Silva |
    And the following communities
      | identifier | name |
      | sample-community | Sample Community |
    And "Joao Silva" is admin of "Sample Community"

  @selenium-fixme
  Scenario: highlight an article before approval of a suggested article
    Given I am on Sample Community's blog
    And I follow "article-options"
    And I follow "Suggest an article"
    And I fill in "Title" with "Suggestion"
    And I fill in "Your name" with "Some Guy"
    And I fill in "Email" with "someguy@somewhere.com"
    And I follow "Save"
    When I am logged in as "joaosilva"
    And I go to sample-community's control panel
    And I follow "menu-toggle"
    And I choose "Accept"
    And I follow "Save tasks"
    # Fix Me: Needs code reformulation to satisfy previous behavior
    And I should see "suggested the publication of the article"
    Then I should see "Highlight this article" within ".task_box"

  @selenium-fixme
  Scenario: an article is suggested and the admin approve it
    Given I am on Sample Community's blog
    And I follow "article-options"
    And I follow "Suggest an article"
    And I fill in "Title" with "Suggestion"
    And I fill in "Your name" with "Some Guy"
    And I fill in "Email" with "someguy@somewhere.com"
    And I follow "Add Lead"
    And I type "This is my suggestion\'s lead" in TinyMCE field "task_article_abstract"
    And I type "I like free software" in TinyMCE field "task_article_body"
    And I follow "Save"
    And I am logged in as "joaosilva"
    And I go to Sample Community's control panel
    And I follow "menu-toggle"
    # Fix Me: Needs code reformulation to satisfy previous behavior
    When I follow "Process requests"
    And I choose "Accept"
    And I follow "Save tasks"
    Then I should see "suggested the publication of the article: Suggestion."
    When I follow "Accept"
    And I select "sample-community/Blog" from "Select the folder where the article must be published"
    And I follow "Apply!"
    And I go to Sample Community's blog
    And I refresh the page
    Then I should see "Suggestion"
    Then I should see "I like free software"
