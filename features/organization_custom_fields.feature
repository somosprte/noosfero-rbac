Feature: organization custom fields
  As a noosfero admin
  I want to choose what fields are active or required for organizations
  In order to have more consistency in the system

  Background:
    Given the following users
      | login     | name       |
      | joaosilva | Joao Silva |
    And I am logged in as "joaosilva"
    And feature "enterprise_registration" is enabled on environment
    And I go to joaosilva's control panel

  Scenario Outline: organization active fields are not displayed on creation
    Given the following <organization> fields are active fields
      | display_name  |
      | contact_email |
      | location      |
    And I follow "Groups" within "#section-relationships"
    When I follow <creation_button>
    Then I should not see "Display name"
    Then I should not see "Contact email"
    Then I should not see "City"
  Examples:
    | organization  | creation_button             |
    | community     | "Create a new community"    |
    | enterprise    | "Register a new enterprise" |

  Scenario Outline: organization active fields are displayed on edition
    Given the following <organization> fields are active fields
      | display_name  |
      | contact_email |
    And the following <organization>
      | name          | identifier    |
      | Organization  | organization  |
    And "Joao Silva" is admin of "Organization"
    And I am on organization's control panel
    And I follow "Informations" within "#section-profile"
    Then I should see "Display name"
    Then I should see "Contact email"
  Examples:
    | organization  |
    | community     |
    | enterprise    |

  Scenario Outline: organization required fields are displayed on creation
    Given the following <organization> fields are required fields
      | display_name  |
      | contact_email |
    And I follow "Groups" within "#section-relationships"
    And I follow <creation_button>
    When I press <confirmation_button>
    Then I should see "Display name can't be blank"
    Then I should see "Contact email can't be blank"
  Examples:
    | organization  | creation_button             | confirmation_button |
    | community     | "Create a new community"    | "Create"            |
    | enterprise    | "Register a new enterprise" |  "Next"             |

  Scenario Outline: organization required fields are displayed on edition
    Given the following <organization> fields are required fields
      | display_name  |
      | contact_email |
    And the following <organization>
      | name          | identifier    | display_name | contact_email | city |
      | Organization  |  organization | organization | bla@bleee.com | city |
    And "Joao Silva" is admin of "Organization"
    And I am on organization's control panel
    And I follow "Informations" within "#section-profile"
    And I fill in the following:
      | Display name  | |
      | Contact email | |
    When I press "Save"
    Then I should see "Display name can't be blank"
    Then I should see "Contact email can't be blank"
  Examples:
    | organization  |
    | community     |
    | enterprise    |

  Scenario Outline: organization signup fields are displayed on creation
    Given the following <organization> fields are signup fields
      | display_name  |
      | contact_email |
      | location      |
    And I follow "Groups" within "#section-relationships"
    When I follow <creation_button>
    Then I should see "Display name"
    Then I should see "Contact email"
    Then I should see "Location"
  Examples:
    | organization  | creation_button             |
    | community     | "Create a new community"    |
    | enterprise    | "Register a new enterprise" |
