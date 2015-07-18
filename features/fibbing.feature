@methods
Feature: Test the functionality specifically related to the Fibonacci aspect.

  Background:
    Given the internal series has been reset

  Scenario: Test the default initial series
    When I invoke method 'series'
    Then the return value should be exactly [0,1,1]
    When I invoke method 'count'
    Then the return value should be exactly 3

  Scenario: Test extending the series with #grow
    When I invoke method 'grow(20)'
    Then the return value should be exactly 23
    When I invoke method 'count'
    Then the return value should be exactly 23

  Scenario Outline: Test frobbing the series with #grow, #shrink, and #terms
    When I set attribute 'terms' to <terms>
    Then the value of attribute 'terms' should be exactly <terms>
    When I set attribute 'terms' to <terms> + 5
    Then the value of attribute 'terms' should be exactly <terms> + 5
    When I set attribute 'terms' to <terms> - 5
    Then the value of attribute 'terms' should be exactly <terms> - 5
    When I set attribute 'terms' to <terms>
    And I invoke method 'shrink(<shrink>)'
    Then the value of attribute 'terms' should be exactly <terms> - <shrink>
    When I set attribute 'terms' to <terms>
    And I invoke method 'grow(<grow>)'
    Then the value of attribute 'terms' should be exactly <terms> + <grow>

    Examples:
      | terms | shrink | grow |
      | 10    | 4      | 5    |
      | 50    | 6      | 7    |
      | 20    | 8      | 9    |

@coverage
  Scenario: Test the #terms growth/shrink code (coverage only)
    When I set attribute 'terms' to 20
    Then the value of attribute 'terms' should be exactly 20
    And I set attribute 'terms' to 30
    Then the value of attribute 'terms' should be exactly 30
    And I set attribute 'terms' to 10
    Then the value of attribute 'terms' should be exactly 10

Scenario: Test the enumeration methods
    When I invoke method 'slice(30)'
    Then the return value should be exactly 832040
    When I invoke method 'count'
    Then the return value should be exactly 31
    When I invoke method 'first'
    Then the return value should be exactly 0

  Scenario: Test the pseudo-enumeration methods
    When I invoke method '[30]'
    Then the return value should be exactly 832040
    When I invoke method 'count'
    Then the return value should be exactly 31
    When I invoke method 'last'
    Then the return value should be exactly 832040

  Scenario: Test extending the series a little using [] notation
    When I invoke method '[20]'
    Then the return value should be exactly 6765
    When I invoke method 'count'
    Then the return value should be exactly 21

  Scenario: Test extending the series a little using the #slice method
    When I invoke method 'slice(20)'
    Then the return value should be exactly 6765
    When I invoke method 'count'
    Then the return value should be exactly 21

  Scenario: Test slicing out of bounds
    When I invoke method 'slice(-20)'
    Then the return value should be exactly nil
    When I invoke method 'count'
    Then the return value should be exactly 3

  Scenario: Test slicing an actual sequence
    When I invoke method '[28,3]'
    Then the return value should be exactly [317811, 514229, 832040]
    When I invoke method 'count'
    Then the return value should be exactly 31

  Scenario Outline: Test the #is_fibonacci? method with first 100 F-numbers
    When I invoke method 'is_fibonacci?(<testval>)'
    Then the return value should be exactly true
    When I invoke method 'is_fibonacci?(<testval> - (<testval> < 5 ? 6 : 1))'
    Then the return value should be exactly false

    Examples:
      |        testval        |
      |                     0 |
      |                     1 |
      |                     1 |
      |                     2 |
      |                     3 |
      |                     5 |
      |                     8 |
      |                    13 |
      |                    21 |
      |                    34 |
      |                    55 |
      |                    89 |
      |                   144 |
      |                   233 |
      |                   377 |
      |                   610 |
      |                   987 |
      |                  1597 |
      |                  2584 |
      |                  4181 |
      |                  6765 |
      |                 10946 |
      |                 17711 |
      |                 28657 |
      |                 46368 |
      |                 75025 |
      |                121393 |
      |                196418 |
      |                317811 |
      |                514229 |
      |                832040 |
      |               1346269 |
      |               2178309 |
      |               3524578 |
      |               5702887 |
      |               9227465 |
      |              14930352 |
      |              24157817 |
      |              39088169 |
      |              63245986 |
      |             102334155 |
      |             165580141 |
      |             267914296 |
      |             433494437 |
      |             701408733 |
      |            1134903170 |
      |            1836311903 |
      |            2971215073 |
      |            4807526976 |
      |            7778742049 |
      |           12586269025 |
      |           20365011074 |
      |           32951280099 |
      |           53316291173 |
      |           86267571272 |
      |          139583862445 |
      |          225851433717 |
      |          365435296162 |
      |          591286729879 |
      |          956722026041 |
      |         1548008755920 |
      |         2504730781961 |
      |         4052739537881 |
      |         6557470319842 |
      |        10610209857723 |
      |        17167680177565 |
      |        27777890035288 |
      |        44945570212853 |
      |        72723460248141 |
      |       117669030460994 |
      |       190392490709135 |
      |       308061521170129 |
      |       498454011879264 |
      |       806515533049393 |
      |      1304969544928657 |
      |      2111485077978050 |
      |      3416454622906707 |
      |      5527939700884757 |
      |      8944394323791464 |
      |     14472334024676221 |
      |     23416728348467685 |
      |     37889062373143906 |
      |     61305790721611591 |
      |     99194853094755497 |
      |    160500643816367088 |
      |    259695496911122585 |
      |    420196140727489673 |
      |    679891637638612258 |
      |   1100087778366101931 |
      |   1779979416004714189 |
      |   2880067194370816120 |
      |   4660046610375530309 |
      |   7540113804746346429 |
      |  12200160415121876738 |
      |  19740274219868223167 |
      |  31940434634990099905 |
      |  51680708854858323072 |
      |  83621143489848422977 |
      | 135301852344706746049 |
      | 218922995834555169026 |
      | 354224848179261915075 |

