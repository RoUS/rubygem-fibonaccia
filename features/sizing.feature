@sizing
Feature: Test our methods for adjusting the length of the series.

  Scenario: Test the default initial series
    When I invoke method 'series'
    Then the return value should be exactly [0,1,1]
    And attribute 'terms' should have value 3

  Scenario: Test that resetting leaves the series still at the default
    When I invoke method 'reset'
    And I query method 'series'
    Then the return value should be exactly [0,1,1]
    And attribute 'terms' should have value 3

  Scenario Outline: Grow the series repeatedly
    When I query attribute 'terms'
    Then the return value should be exactly <terms0>
    And I invoke method 'grow(<nterms>)'
    Then the return value should be exactly <terms1>
    And attribute 'terms' should have value <terms1>

    Examples:
      | terms0 | nterms | terms1 |
      | 3      | 1      | 4      |
      | 4      | 6      | 10     |
      | 10     | 0      | 10     |
      | 10     | 1000   | 1010   |
      | 1010   | 10280  | 11290  |

  Scenario: Test the series in the next scenario after the growth scenario
    When I query attribute 'terms'
    Then the return value should be exactly 11290

  Scenario: Test that resetting restores to just the seed
    When I invoke method 'reset'
    And I query method 'series'
    Then the return value should be exactly [0,1,1]
    And attribute 'terms' should have value 3

  Scenario Outline: Test setting explicit term counts
    When I set attribute 'terms' to <setting>
    Then the return value should be exactly <expected>
    And attribute 'terms' should have value <expected>

    Examples:
      | setting | expected              |
      | 1024    | 1024                  |
      | 0       | 3                     |
      | 0       | 3                     |
      | 0       | 3                     |
      | 1       | 3                     |
      | 2       | 3                     |
      | 11290   | 11290                 |

  Scenario Outline: Test shrinking
    When I query attribute 'terms'
    Then the return value should be exactly <terms0>
    And I invoke method 'shrink(<nterms>)'
    Then the return value should be exactly <terms1>
    And attribute 'terms' should have value <terms1>

    Examples:
      | terms0 | nterms | terms1 |
      | 11290  | 10280  | 1010   |
      | 1010   | 0      | 1010   |
      | 1010   | 1000   | 10     |
      | 10     | 4      | 6      |
      | 6      | 4      | 3      |
      | 3      | 100    | 3      |

