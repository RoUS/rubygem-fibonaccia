@exceptions
Feature: Test that all the things that *should* raise exceptions -- do.

  Scenario: Test that including the module gives a warning
    When I include the Fibonaccia module
    Then stderr should match:
      """
      is not intended for use as a mix-in
      """

  Scenario: Test that non-integer slice parameters raise exceptions
    When I invoke method slice("foo")
    Then it should raise an exception of type ArgumentError
    When I invoke method slice("foo", 1)
    Then it should raise an exception of type ArgumentError
    When I invoke method slice(1, "foo")
    Then it should raise an exception of type ArgumentError
    When I invoke method slice("foo", "bar")
    Then it should raise an exception of type ArgumentError
