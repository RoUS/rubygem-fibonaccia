@slicing
@slicing_sequences
@slicing_growth

Feature: Test that slicing past the current end of the series will extend it

  Scenario Outline: Test growth-by-slicing
    Given the internal series has been reset
    When I invoke method '[<index>,<nterms>]'
    Then the return value should be exactly <slice>
    And the value of attribute 'terms' should be exactly <terms>

    Examples:
      | index | nterms | slice                                         | terms |
      |     0 | 0      | 0                                             | 3     |
      |    10 | 2      | [55,89]                                       | 12    |
      |   100 | 2      | [354224848179261915075,573147844013817084101] | 102   |

