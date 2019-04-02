Feature: comment
  As a visitor
  I want to reply comments

  Background:
    Given the following users
      | login   |
      | booking |
    And the following articles
      | owner   | name               |
      | booking | article to comment |
      | booking | another article    |
    And the following comments
      | article            | author  | title        | body                        |
      | article to comment | booking | root comment | this comment is not a reply |
      | another article    | booking | some comment | this is my very own comment |

  Scenario: not show any reply form by default
    When I go to /booking/article-to-comment
    Then I should not see "Leave your comment"

  @selenium-fixme
  Scenario: show error messages when make a blank comment reply
    Given I am logged in as "booking"
    And I go to /booking/article-to-comment
    And I follow "Reply" within ".comments-action-bar"
    When I press "Post comment" within ".comment-balloon"
    Then I should see "Title can't be blank" within "div.comment_reply"
    And I should see "Body can't be blank" within "div.comment_reply"

  @selenium
  Scenario: render reply form
    Given I am on /booking/article-to-comment
    And I follow "comment-options"
    When I follow "Reply"
    Then I should see "Name"
    Then I should see "e-mail"

  # The text is hidden but the detector gets it anyway
  @selenium-fixme
  Scenario: cancel comment reply
    Given I am on /booking/article-to-comment
    And I follow "Reply" within ".comments-action-bar"
    When I follow "Cancel" within ".comment-balloon"
    Then I should not see "Enter your comment" within "div.comment_reply.closed"

  @selenium-fixme
  Scenario: not render same reply form twice
    Given I am on /booking/article-to-comment
    And I follow "Reply" within ".comments-action-bar"
    And I follow "Cancel" within ".comment-balloon"
    When I follow "Reply" within ".comments-action-bar"
    Then there should be 1 "comment_form" within "comment_reply"
    And I should see "Enter your comment" within "div.comment_reply.opened"

  @selenium-fixme
  Scenario: reply a comment
    Given I go to /booking/another-article
    And I follow "Reply" within ".comments-action-bar"
    And I fill in "Name" within "comment-balloon" with "Joey"
    And I fill in "e-mail" within "comment-balloon" with "joey@ramones.com"
    And I fill in "Title" within "comment-balloon" with "Hey ho, let's go!"
    And I fill in "Enter your comment" within "comment-balloon" with "Hey ho, let's go!"
    When I press "Post comment" within ".comment-balloon"
    Then I should see "Hey ho, let's go" within "ul.comment-replies"
    And there should be 1 "comment-replies" within "article-comment"

  @selenium-fixme
  Scenario: redirect to right place after reply a picture comment
    Given the following files
      | owner   | file      | mime      |
      | booking | rails.png | image/png |
    And the following comment
      | article   | author  | title        | body                        |
      | rails.png | booking | root comment | this comment is not a reply |
    Given I am logged in as "booking"
    And I go to /booking/rails.png?view=true
    And I follow "Reply" within ".comments-action-bar"
    And I fill in "Title" within "comment-balloon" with "Hey ho, let's go!"
    And I fill in "Enter your comment" within "comment-balloon" with "Hey ho, let's go!"
    When I press "Post comment" within ".comment-balloon"
    Then I should be exactly on /booking/rails.png?view=true
