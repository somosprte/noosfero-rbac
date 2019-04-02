Feature: create content on cms
  As a noosfero user
  I want to create articles and upload files

  Background:
    Given the following users
      | login     | name       |
      | joaosilva | Joao Silva |
    And I am logged in as "joaosilva"
    And I am on joaosilva's cms

  Scenario: open page to select type of content
    Given I follow "New content"
    Then I should see "Choose the type of content"

  Scenario: list all content types
    Given I follow "New content"
    Then I should see "Text article"
     And I should see "Folder"
     And I should see "Blog"
     And I should see "Uploaded file"
     And I should see "Event"

  Scenario: create a folder
    Given I follow "New content"
    When I follow "Folder"
    And I fill in "Title" with "My Folder"
    And I press "Save"
    And I go to joaosilva's cms
    Then I should see "My Folder"

  Scenario: create a Blog
    Given I follow "New content"
    When I follow "Blog"
    And I fill in "Title" with "My blog"
    And I fill in "Address" with "my-blog"
    And I press "Save"
    And I go to joaosilva's cms
    Then I should see "My blog"

  Scenario: create an event
    Given I follow "New content"
    When I follow "Event"
    And I fill in "Title" with "My event"
    And I press "Save"
    And I go to joaosilva's cms
    Then I should see "My event"

  Scenario: redirect to upload files if choose UploadedFile
    Given I follow "New content"
    When I follow "Uploaded file"
    Then I should be on /myprofile/joaosilva/cms/upload_files

  Scenario: redirect to new if choose UploadedFile with single upload files cheked in profile
    Given I am on joaosilva's control panel
    And I follow "Preferences" within "#section-profile"
    And I check "profile_data[allow_single_file]"
    And I press "Save"
    And I follow "New" within "#section-content"
    When I follow "Uploaded file"
    Then I should be on /myprofile/joaosilva/cms/new
