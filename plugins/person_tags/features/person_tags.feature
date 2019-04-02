Feature: person tags

Background:
  Given the following users
    | login   |
    | joao    |
  And I am logged in as "joao"
  And "PersonTags" plugin is enabled

@fixme
Scenario: add tags to person
  Given I am on joao's control panel
  And I follow "Edit Profile"
  When I fill in "profile_data_tag_list" with "linux,debian"
  And I press "Save"
  And I go to joao's control panel
  And I follow "Edit Profile"
  Then the "profile_data_tag_list" field should contain "linux"
  And the "profile_data_tag_list" field should contain "debian"
