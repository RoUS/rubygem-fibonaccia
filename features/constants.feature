@constants
Feature: Test the various constants we provide

  Scenario Outline: Test that the PHI values are of the correct class
    When I invoke method '<testmethod>'
    Then the return value should be a kind of <expectedclass>

    Examples:
      | testmethod | expectedclass |
      | PHI        | Float         |
      | PHI(false) | Float         |
      | PHI(true)  | BigDecimal    |

  Scenario Outline: Test that the PHI values are as expected
    When I invoke method '<testmethod>'
    Then the return value should be exactly <expected>

    Examples:
      | testmethod | expected                    |
      | PHI        | Fibonaccia::PHI_Float       |
      | PHI(false) | Fibonaccia::PHI_Float       |
      | PHI(true)  | Fibonaccia::PHI_BigDecimal  |

