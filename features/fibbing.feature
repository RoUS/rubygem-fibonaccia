@methods
Feature: Test the functionality specifically related to the Fibonacci aspect.

  Background:
    Given the internal series has been reset

  Scenario: Test the default initial series
    When I invoke method 'series'
    Then the return value should be [0,1,1]
    When I invoke method 'count'
    Then the return value should be 3

  Scenario: Test extending the series a little using [] notation
    When I invoke method '[20]'
    Then the return value should be 6765
    When I invoke method 'count'
    Then the return value should be 21

  Scenario: Test extending the series a little using the #slice method
    When I invoke method 'slice(20)'
    Then the return value should be 6765
    When I invoke method 'count'
    Then the return value should be 21

  Scenario: Test slicing out of bounds
    When I invoke method 'slice(-20)'
    Then the return value should be nil
    When I invoke method 'count'
    Then the return value should be 3

  Scenario: Test slicing an actual sequence
    When I invoke method '[28,3]'
    Then the return value should be [317811, 514229, 832040]
    When I invoke method 'count'
    Then the return value should be 31

  Scenario: Test the enumeration methods
    When I invoke method '[30]'
    Then the return value should be 832040
    When I invoke method 'count'
    Then the return value should be 31
    When I invoke method 'first'
    Then the return value should be 0
    When I invoke method 'last'
    Then the return value should be 832040

  Scenario: Test the #is_fibonacci? method
    When I invoke method 'is_fibonacci?(0)'
    Then the return value should be true
    When I invoke method 'is_fibonacci?(1024)'
    Then the return value should be false

