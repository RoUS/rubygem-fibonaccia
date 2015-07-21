@enumeration
Feature: Test the useability of the mixed-in Enumerable methods

  Background:
    Given the internal series has been reset

  Scenario: Test the #count and #terms methods
    Given I invoke method 'slice(30)'
    Then the return value should be exactly 832040
    And the value of attribute 'terms' should be exactly 31
    And the value of attribute 'count' should be exactly 31

  Scenario: Test the #first and #last methods
    Given I invoke method 'slice(30)'
    And the value of attribute 'first' should be exactly 0
    And the value of attribute 'last' should be exactly 832040

  Scenario: Test slicing out of bounds
    When I invoke method 'slice(-20)'
    Then the return value should be exactly nil
    And the value of attribute 'terms' should be exactly 3

