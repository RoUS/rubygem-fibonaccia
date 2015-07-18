@slicing
@slicing_sequences
Feature: Test slicing multi-element pieces out of the series

  Scenario: Resetting the series before the aggregatative scenario
    When the internal series has been reset
    Then the value of attribute 'terms' should be exactly 3

  Scenario Outline: Test slicing multi-element values out of the minimal series
    When I invoke method '[<index>,<nterms>]'
    Then the return value should be exactly <slice>
    And the value of attribute 'terms' should be exactly <terms>
    And the value of attribute 'series' should be exactly <series>

    Examples:
      | index | nterms | slice    | terms | series      |
      |     0 | 0      | 0        | 3     | [0,1,1]     |
      |     0 | 1      | 0        | 3     | [0,1,1]     |
      |     0 | 2      | [0,1]    | 3     | [0,1,1]     |
      |     0 | 3      | [0,1,1]  | 3     | [0,1,1]     |
      |     0 | -1     | 0        | 3     | [0,1,1]     |
      |    -1 | 1      | 1        | 3     | [0,1,1]     |
      |     1 | 0      | 1        | 3     | [0,1,1]     |
      |     1 | 1      | 1        | 3     | [0,1,1]     |
      |     1 | 2      | [1,1]    | 3     | [0,1,1]     |
      |     1 | 3      | [1,1,2]  | 4     | [0,1,1,2]   |
      |     1 | -1     | 1        | 4     | [0,1,1,2]   |
      |    -1 | 1      | 2        | 4     | [0,1,1,2]   |
      |     2 | 0      | 1        | 4     | [0,1,1,2]   |
      |     2 | 1      | 1        | 4     | [0,1,1,2]   |
      |     2 | 2      | [1,2]    | 4     | [0,1,1,2]   |
      |     2 | 3      | [1,2,3]  | 5     | [0,1,1,2,3] |
      |    -1 | 1      | 3        | 5     | [0,1,1,2,3] |
      |     2 | 0      | 1        | 5     | [0,1,1,2,3] |
      |     2 | 1      | 1        | 5     | [0,1,1,2,3] |
      |     2 | 2      | [1,2]    | 5     | [0,1,1,2,3] |
      |     2 | 3      | [1,2,3]  | 5     | [0,1,1,2,3] |
      |    -1 | 1      | 3        | 5     | [0,1,1,2,3] |

