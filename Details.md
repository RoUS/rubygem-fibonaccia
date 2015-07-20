# Fibonaccia Details

[![Gem Version](https://badge.fury.io/rb/fibonaccia.svg)](http://badge.fury.io/rb/fibonaccia)

*As though there weren't enough Ruby gems for dealing with the
Fibonacci sequence.. here's another one!*

---
### <a name="TOC">Table of Contents</a>

* [Introduduction](#Introduction)
* [Internals](#Internals)
  * [Automatic Growth](#Automatic_Growth)
* [Usage](#Usage)
  * [Querying](#Querying)
  * [Metadata](#Metadata)
  * [Fibonacci-ness](#Fibonacci-ness)
  * [Constants](#Constants)
  * [Memory considerations](#Memory_considerations)
* [Licence and Copyright](#Licence_and_Copyright)

---

## <a name="Introduction">Introduction</a>

`Fibonaccia` is a very simple package for accessing the series of
[Fibonacci numbers](https://en.wikipedia.org/wiki/Fibonacci_number).
It's implemented as a set of methods and constants wrapped in the `Fibonaccia`
namespace.  All methods are module methods; it is *not* intended for
use as a mix-in; although attempting to import it with `include` will
do no harm, it won't accomplish much other than generating a warning
on `$stdout`.

`Fibonaccia` also provides the irrational constant
[`PHI` (`φ`)](#Constants), which represents the
[Golden Ratio](https://en.wikipedia.org/wiki/Golden_ratio) but which isn't in
Ruby's own *Math* module.  `φ` is provided in both `Float` precision
and as a `BigDecimal` ( *q.v.*) value.

---

<a name="Zero-based">**Note:**</a> `Fibonaccia` uses Ruby semantics
for dealing with the series.  Most importantly, remember when querying
it that it is **zero-based** -- that is, the first term has index **`0`**.

---

## <a name="Internals">Internals</a>

`Fibonaccia` internally maintains an array of the Fibonacci sequence
covering whatever terms have been accessed through its API.  That is,
if you requested the one-thousandth term, the internal array would
contain *at least* 1000 elements.

This internal array is referred to as the **internal series** in the
API documentation.  It is not directly accessible from outside the
module; the {Fibonaccia.series} method returns a copy.

### <a name="Automatic_Growth">Automatic Growth and Controlling the Size of the Series</a>

If you refer to a term that does not [yet] exist in the internal
series, the series will be automatically extended to include it.  It
is never trimmed automatically, so memory consumption may be a concern
-- expecially if you use the {Fibonaccia.series} method, since that
will make an additional copy of the array.

The following example illustrates this:

```ruby
Fibonaccia.series
=> [ 0, 1, 1 ]
Fibonaccia.terms
=> 3
Fibonaccia[12]
=> 144
Fibonaccia.series
=> [ 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144 ]
Fibonaccia.terms
=> 13
Fibonaccia[8]
=> 21
Fibonaccia.series
=> [ 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144 ]
Fibonaccia.terms
=> 13
```

You can explicitly control the size of the internal series with the
following methods:

* {Fibonaccia.reset}
  -- Resets the internal series to the basic default set of terms (see below).
* {Fibonaccia.grow}( *n*)
  -- Extends the internal series by *`n`* terms.
* {Fibonaccia.shrink}( *n*)
  -- Shrinks the internal series by removing *`n`* terms from the end.
* {Fibonaccia.terms=} *n*
  -- Sets the total number of terms in the internal series, which will
     be grown or shrunk as needed.

The internal series **always** includes the first three Fibonacci terms:
`[ 0, 1, 1 ]`.  You cannot shrink or set the number of terms to fewer than
3.

## <a name="Usage">Usage</a>

All of the methods of the public API are documented in the usual
manner and places; this section is intended to provide a little more
detail about them than just the bare calling sequence.

### <a name="Slicing_Indexing">Slicing/Indexing</a>

The internal series can be queried for single terms or slices of
consecutive ones, using either the {Fibonaccia.slice} method or the
shorthand (and possibly more readable) alias {Fibonaccia.[]}.

You can request a specific term in the Fibonacci series:

```ruby
thirty_fifth = Fibonaccia[34]                   # remember: zero-based!
```

or a slice:

```ruby
fourth_through_seventh = Fibonaccia[3,3]        # remember: zero-based!
fourth_through_seventh = Fibonaccia.slice(3,3)
```

If any of the terms you request are beyond the end of the internal
series' current list of values, it will
[automatically be grown](#Automatic_Growth)
to include them.

The normal `Array` method semantics are available; for example:

```ruby
Fibonaccia[-1]                                  # return the last term in the internal series
Fibonaccia[-3,3]                                # return the last 3 terms
```

Most of the methods provided by the `Enumerable` mix-in ( *q.v.*) are
available and apply to the internal series:

```ruby
Fibonaccia.reset
Fibonaccia.last
=> 1
Fibonaccia.include?(144)
=> false                                        # internal series not extended far enough yet
Fibonaccia.terms = 13
Fibonaccia.include?(144)
=> true
Fibonaccia.series.reduce(:+)                    # cumulative sum of internal series
=> 376
```

Although it might seem appropriate to have `#include?` and `#member?`
return `true` if their arguments exist somewhere in the Fibonacci
series, that would conflict with their canonical meanings.
Consequently, the
'[is this arbitrary number in the Fibonacci series](#Fibonacci-ness)'
test has its own method, {Fibonaccia.is_fibonacci?}.

### <a name="Metadata">Metadata</a>

Although the internal series is not directly accessible by user code,
you can obtain a *copy* using the {Fibonaccia.series} method:

```ruby
series_so_far = Fibonaccia.series
```

Querying the {Fibonaccia.terms} attribute will return the number of
terms currently in the internal series:

```ruby
term_count = Fibonaccia.terms
```

### <a name="Fibonacci-ness">Fibonacci-ness</a>
or check to see if an arbitrary integer is a Fibonacci number:

```ruby
Fibonaccia.is_fibonacci?(354224848179261915075)
=> true
Fibonaccia.is_fibonacci?(354224848179261915075 + 1)
=> false
```

If memory becomes a concern (see
[Memory considerations](#Memory_considerations)),
you can trim the internal series back to the initial three terms:

```ruby
Fibonaccia.reset
Fibonaccia.terms
=> 3
```

You can grow or shrink the list by any number of terms (although you
**cannot** shrink it to fewer than 3):

```ruby
Fibonaccia.terms
=> 3
Fibonaccia.grow(20)
=> 23
Fibonaccia.terms
=> 23
Fibonaccia.shrink(10)
=> 13
Fibonaccia.terms
=> 13
```

or you can set the size of the series to any arbitrary number of terms
(again, you cannot set the series to fewer than 3 terms):

```ruby
Fibonaccia.reset
Fibonaccia.terms
=> 3
Fibonaccia.terms = 2048
Fibonaccia.terms
=> 2048
```

### <a name="Constants">Constants</a>

`Fibonaccia` provides only a single constant -- `PHI` (`φ`), the
[Golden Ratio](https://en.wikipedia.org/wiki/Golden_ratio).  It
is available as both a `Float` of implementation-specific precision
and as an arbitrary-precision `BigDecimal` ( *q.v.*).

There are two ways of accessing the constant:

```ruby
#
# Using conventional Ruby constant syntax:
#
Fibonaccia::PHI                                 # Float
Fibonaccia::PHI(false)                          # Float
Fibonaccia::PHI(true)                           # BigDecimal
#
# Or as a method:
#
Fibonaccia.PHI                                  # Float
Fibonaccia.PHI(false)                           # Float
Fibonaccia.PHI(true)                            # BigDecimal
```

The latter syntax is recommended and preferred.

### <a name="Memory_considerations">Memory considerations</a>

Although the internal series is expanded only at need, the fact that
it is never automatically trimmed back means that the more terms are
requested, the more memory will be consumed by it.  Although this
shouldn't be an issue unless you're dealing with thousands of terms,
it *can* be a concern if you use the {Fibonaccia.series} method -- as
each invocation thereof will return a *duplicate* of the internal
series as it currently stands.  (That is, extending the internal
series after making a copy with {Fibonaccia.series} does **not**
result in the copy being extended as well.)

You can use the {Fibonaccia.terms} method to determine how many terms
are currently in the internal series, and so get an idea of how much
of a resource impact an invocation of {Fibonaccia.series} would have.

If you seed to work with the series itself rather than through the
methods provided by the module, you can reduce the impact by obtaining
the copy and then resetting the internal series back to its minimal
usage:

```ruby
Fibonaccia.terms = 100000                       # internal series = 100,000 terms
my_copy = Fibonaccia.series                     # plus a copy, also of 100,000 terms
Fibonaccia.reset                                # now just your copy,
                                                # plus 3 terms in the internal series
```

## <a name="Licence_and_Copyright">Licence and Copyright</a>

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

Your distribution should include a copy of the `LICENCE.txt` file.
