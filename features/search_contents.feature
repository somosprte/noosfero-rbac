Feature: search contents
  As a noosfero user
  I want to search contents
  In order to find ones that interest me

  Background:
    Given the following users
      | login     | name       |
      | joaosilva | Joao Silva |
    And the following articles
      | owner     | name                 | body                                          |
      | joaosilva | bees and butterflies | this is an article about bees and butterflies |
      | joaosilva | whales and dolphins  | this is an article about whales and dolphins  |

  Scenario: show recent content on index
    When I go to the search articles page
    Then I should see "bees and butterflies" within "#search-results"
    And I should see "whales and dolphins" within "#search-results"

  Scenario: simple search for text articles
    When I search contents for "whales"
    Then I should see "whales and dolphins" within ".search-text-article-item"
    And I should see "whales and dolphins" within ".only-one-result-box"
    And I should not see "bees and butterflies"
    When I follow "whales and dolphins"
    Then I should be on article "whales and dolphins"

  Scenario: simple search for event
    Given the following communities
      | identifier  | name |
      | nice-people | Nice people |
    And the following events
      | owner | name | start_date | end_date |
      | nice-people | Group meeting | 2009-01-01 | 2009-01-02 |
      | nice-people | John Doe's birthday | 2009-09-01 | 2009-09-02 |
    When I search contents for "birthday"
    Then I should see "John Doe's birthday" within ".search-event-item"
    And I should see "Start date"
    And I should see "September 1, 2009"
    And I should see "End date"
    And I should see "September 2, 2009"
    And I should not see "Group meeting"
    When I follow "John Doe's birthday"
    Then I should be on article "John Doe's birthday"

  Scenario: simple search for folder
    Given the following folders
      | owner | name |
      | joaosilva | Music Folder |
      | joaosilva | Videos Folder |
    When I search contents for "Music"
    Then I should see "Music Folder"
    And I should see "" within ".search-folder-item"
    And I should not see "Videos Folder"
    And I follow "Music Folder"
    Then I should be on article "Music Folder"

  Scenario: simple search for forum
    Given the following forums
      | owner | name |
      | joaosilva | Games Forum |
      | joaosilva | Movies Folder |
    When I search contents for "Games"
    Then I should see "Games Forum" within ".main-content"
    And I should see "None" within ".search-forum-items"
    And I should not see "Movies Folder"
    When I follow "Games Forum"
    Then I should be on article "Games Forum"

  Scenario: simple search for gallery
    Given the following galleries
      | owner | name |
      | joaosilva | Landscape Photos |
      | joaosilva | People Photos |
    When I search contents for "Landscape"
    Then I should see "Landscape Photos" within ".main-content"
    And I should not see "People Photos"
    When I follow "Landscape Photos"

  Scenario: simple search for uploaded file
    Given the following uploaded files
      | owner | filename |
      | joaosilva | rails.png |
      | joaosilva | shoes.png |
    When I search contents for "rails"
    Then I should see "rails.png" within ".main-content"
    And I should not see "shoes"
    When I follow "rails"
    Then I should be on article "rails"

  Scenario: show event search results without end date
    Given the following communities
      | identifier  | name |
      | nice-people | Nice people |
    And the following events
      | owner | name |
      | nice-people | John Doe's birthday |
    When I search contents for "birthday"
    Then I should see "John Doe's birthday" within ".search-event-item"
    And I should not see "End date"

  Scenario: show and link last items on folder search results
    Given the following folders
      | owner | name |
      | joaosilva | Music Folder |
    And the following articles
      | owner | name | parent |
      | joaosilva | Steven Wilson | Music Folder |
      | joaosilva | Porcupine Tree | Music Folder |
      | joaosilva | Blackfield | Music Folder |
    When I search contents for "Music"
    Then I should see "Last items" within ".search-folder-items"
    And I should see "Blackfield"
    And I should see "Porcupine Tree"
    And I should see "Steven Wilson"
    When I follow "Porcupine Tree"
    Then I should be on article "Porcupine Tree"

  Scenario: show and link last topics on forum search results
    Given the following forums
      | owner | name |
      | joaosilva | Games Forum |
    And the following articles
      | owner | name | parent |
      | joaosilva | Mass Effect 3 | Games Forum |
      | joaosilva | The Witcher 2 | Games Forum |
      | joaosilva | Syndicate | Games Forum |
    And the following rss feeds
      | joaosilva | Diablo 3 News Feed | Games Forum |
    When I search contents for "Games"
    Then I should see "Last topics" within ".search-forum-items"
    And I should see "Syndicate"
    And I should see "The Witcher 2"
    And I should see "Mass Effect 3"
    And I should not see "Diablo 3"
    When I follow "The Witcher 2"
    Then I should be on article "The Witcher 2"

  Scenario: link to parent in uploaded file search results
    Given the following folders
      | owner | name |
      | joaosilva | Folder for Uploaded Files |
    Given the following uploaded files
      | owner | parent | filename |
      | joaosilva | Folder for Uploaded Files | rails.png |
    When I search contents for "rails.png"
    Then I should see "Folder for Uploaded Files" within ".search-uploaded-file-parent"
    When I follow "Folder for Uploaded Files"
    Then I should be on article "Folder for Uploaded Files"

@selenium-fixme
  Scenario: link to author on search results
    When I go to the search articles page
    And I fill in "search-input" with "whales"
    And I follow "Search" within ".search-form"
    Then I should see "Profile" within ".search-article-profile"
    Then I should see "Joao Silva" within ".search-article-profile-name"
    When I follow "Joao Silva"
    And I wait for 1 seconds
    Then I should be on joaosilva's profile

  Scenario: show clean description excerpt on search results
    Given the following articles
      | owner     | name        | body |
      | joaosilva | Herreninsel | The island    <b>Herreninsel</b>,    with an area of 238 hectares, is the biggest of the three main islands of the Chiemsee, a lake in the state of Bavaria, Germany. Together with the islands of Fraueninsel and Krautinsel it forms the municipality of Chiemsee. |
    When I go to the search articles page
    And I fill in "search-input" with "island"
    And I follow "Search" within ".search-form"
    Then I should see "Description" within ".search-article-description"
    And I should see "The island Herreninsel, with" within ".search-article-description"
    And I should see "and Kraut..." within ".search-article-description"

  @selenium
  Scenario: do not show description on search results
    Given the following articles
      | owner     | name        | body |
      | joaosilva | Herreninsel |      |
    When I go to the search articles page
    And I fill in "search-input" with "Herreninsel"
    And I follow "Search" within ".search-form"
    Then I should not see "Description"

  Scenario: link to tags on search results
    Given the following tags
      | article              | name        |
      | bees and butterflies | Hymenoptera |
      | bees and butterflies | Lepidoptera |
    When I go to the search articles page
    And I fill in "search-input" with "bees"
    And I follow "Search" within ".search-form"
    Then I should see "Tags" within ".search-article-tags"
    And I should see "Hymenoptera" within ".search-article-tags"
    And I should see "Lepidoptera" within ".search-article-tags"
    When I follow "Hymenoptera"
    Then I should be on Hymenoptera's tag page

  Scenario: do not show tags in search results
    When I go to the search articles page
    And I fill in "search-input" with "dolphins"
    And I follow "Search" within ".search-form"
    Then I should not see "Tags"

  Scenario: link to categories on search results
    Given the following category
      | name           |
      | Soviet |
    And the following articles
      | owner     | name           | body                       | category       |
      | joaosilva | Sergei Sorokin | Retired ice hockey player  | soviet |
    When I go to the search articles page
    And I fill in "search-input" with "hockey"
    And I follow "Search" within ".search-form"
    Then I should see "Categories" within ".search-article-categories"
    And I should see "Soviet" within ".search-article-category"

  Scenario: do not show categories on search results
    When I go to the search articles page
    And I fill in "search-input" with "whales"
    And I follow "Search" within ".search-form"
    Then I should see "whales and dolphins"
    And I should not see "Categories"

  Scenario: show date of last update from original author
    When I search contents for "whales"
    Then I should see "Updated at" within ".search-article-author-changes"

  Scenario: show date of last update from another author
    Given the following users
      | login | name |
      | sglaspell | Susan Glaspell |
    And the article "whales and dolphins" is updated by "Susan Glaspell"
    When I search contents for "whales"
    Then I should see "by Susan Glaspell at" within ".search-article-author-changes"

  Scenario: show basic info on blog search results
    Given the following blogs
      | owner | name |
      | joaosilva | JSilva blog |
    When I search contents for "JSilva"
    Then I should see "JSilva blog" within ".search-result-title"
    And The page should contain ".icon-content-blog"

  Scenario: show and link last posts on blog search results
    Given the following blogs
      | owner | name |
      | joaosilva | JSilva blog |
    And the following articles
      | owner | parent        | name |
      | joaosilva | JSilva blog | post #1 |
      | joaosilva | JSilva blog | post #2 |
      | joaosilva | JSilva blog | post #4 |
    And the following rss feeds
      | joaosilva | JSilva blog | post #3 |
    When I search contents for "JSilva"
    Then I should see "Last posts" within ".main-content"
    And I should see "post #1"
    And I should see "post #2"
    And I should not see "post #3"
    And I should see "post #4"
    When I follow "post #1"
    Then I should be on article "post #1"

  Scenario: show empty last posts on blog search results
    Given the following blogs
      | owner | name |
      | joaosilva | JSilva blog |
    When I search contents for "JSilva"
    Then I should see "None" within ".search-blog-items"

  Scenario: find enterprises without exact query
    When I go to the search articles page
    And I fill in "search-input" with "bees and"
    And I follow "Search" within ".search-form"
    Then I should see "bees and butterflies" within "#search-results"
