@exceptions
Feature: Test that all the things that *should* raise exceptions -- do.

  Scenario: Test that including the module gives a warning
    When I include the Fibonaccia module
    Then stderr should match:
      """
      is not intended for use as a mix-in
      """

  Scenario Outline: Test that #shrink, #grow, and #limit raise an exception on bad arguments
    When I invoke method '<testmethod>("foo")'
    Then it should raise an exception of type StandardError
    And it should raise an exception of type Fibonaccia::Exception
    And it should raise an exception of type Fibonaccia::NotPositiveInteger
    And it should raise an exception with exc.to_s containing 'non-negative integer'
    And it should raise an exception with exc.to_str containing 'non-negative integer'

    Examples:
      | testmethod |
      | shrink     |
      | grow       |
      | terms=     |

  Scenario: Test that non-integer slice parameters raise exceptions
    When I invoke method slice("foo")
    Then it should raise an exception of type ArgumentError
    When I invoke method slice("foo", 1)
    Then it should raise an exception of type ArgumentError
    When I invoke method slice(1, "foo")
    Then it should raise an exception of type ArgumentError
    When I invoke method slice("foo", "bar")
    Then it should raise an exception of type ArgumentError

  Scenario: Test that non-integer slice ([]) parameters raise exceptions
    When I invoke method ["foo"]
    Then it should raise an exception of type ArgumentError
    When I invoke method ["foo", 1]
    Then it should raise an exception of type ArgumentError
    When I invoke method [1, "foo"]
    Then it should raise an exception of type ArgumentError
    When I invoke method ["foo", "bar"]
    Then it should raise an exception of type ArgumentError

