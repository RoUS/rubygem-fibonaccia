# Fibonaccia

[![Gem Version](https://badge.fury.io/rb/fibonaccia.svg)](http://badge.fury.io/rb/fibonaccia)

*As though there weren't enough Ruby gems for dealing with the Fibonacci sequence.. here's another one!*

`Fibonaccia` is a very simple package for accessing the series of
[Fibonacci numbers](https://en.wikipedia.org/wiki/Fibonacci_number).

`Fibonaccia` also provides the irrational constant `PHI` (`φ`), which
represents the [Golden Ratio](https://en.wikipedia.org/wiki/Golden_ratio)
bu which isn't in Ruby's own *Math* module.

You can request a specific term in the Fibonacci series:

    thirty_fifth = Fibonaccia[35]

or a slice:

    fourth_through_seventh = Fibonaccia[4, 3]
    fourth_through_seventh = Fibonaccia.slice(4, 3)

or the complete series as far as the module has been requested to
derive it:

    series_so_far = Fibonaccia.series

or the number of terms in the series-so-far:

    term_count = Fibonaccia.count

`Fibonaccia` attempts to be memory-efficient by only deriving the
series to the extent needed by the caller (*i.e.*, if you ask for the
tenth Fibonacci number, `Fibonaccia` will internally extend its series
to eleven (terms) if it hasn't already; if you then ask for the eighth
number, it will return the value from the already-extended internal
series).

    Fibonaccia.series
    => [ 0, 1, 1 ]
    Fibonaccia.count
    => 3
    Fibonaccia[12]
    => 144
    Fibonaccia.series
    => [ 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144 ]
    Fibonaccia.count
    => 13
    Fibonaccia[8]
    => 21
    Fibonaccia.series
    => [ 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144 ]
    Fibonaccia.count
    => 13

## Installation

Add this line to your application's Gemfile:

```ruby
gem('fibonaccia')
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fibonaccia

## Usage

```ruby
require('fibonaccia')

```

## TODO

1. Provide interface for obtaining coördinates on a golden spiral.

## Contributing

1. Fork it ( https://github.com/RoUS/fibonaccia/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Licence

`Fibonaccia` is copyright © 2015 by Ken Coar, and is made available
under the terms of the Apache Licence 2.0:

```
   Copyright © 2015 Ken Coar

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
```
