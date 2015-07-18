@slicing

Feature: Test accessing the internal series through basic slices.

  Scenario: Test the default initial series
    When I invoke method 'reset'
    Then the value of attribute 'series' should be exactly [0,1,1]

  Scenario Outline: Test slicing single values out of the minimal series using #slice
    Given the internal series has been reset
    When I invoke method 'slice(<index>)'
    Then the return value should be exactly <slice>
    And the value of attribute 'terms' should be exactly <terms>

    Examples:
      | index | slice    | terms |
      |     0 | 0        | 3     |
      |     1 | 1        | 3     |
      |     2 | 1        | 3     |
      |    -1 | 1        | 3     |

  Scenario Outline: Test slicing single values out of the minimal series using #[]
    Given the internal series has been reset
    When I invoke method '[<index>]'
    Then the return value should be exactly <slice>
    And the value of attribute 'terms' should be exactly <terms>

    Examples:
      | index | slice    | terms |
      |     0 | 0        | 3     |
      |     1 | 1        | 3     |
      |     2 | 1        | 3     |
      |    -1 | 1        | 3     |


