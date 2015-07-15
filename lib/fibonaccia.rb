# -*- coding: utf-8 -*-
#--
#   Copyright © 2015 Ken Coar
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#++

require('fibonaccia/version')
require('fibonaccia/exceptions')
require('byebug')

#
# The *Fibonaccia* module simply provides three things to Ruby code:
#
# 1. A constant, <tt>Fibonaccia::PHI</tt> (φ), which is the value of
#    the Golden Ratio (see the
#    {https://en.wikipedia.org/wiki/Golden_ratio Wikipedia article})
#    to whatever precision Ruby is using;
# 2. The Fibonacci sequence, to however many places you desire (and your resources
#    can support);
# 3. Coördinates to construct a {https://en.wikipedia.org/wiki/Golden_spiral golden spiral}
#    (<b>not</b> the Fibonacci spiral, which is an approximation of
#    the golden spiral), again to the precision specified by the
#    caller.
#
# <b><i>N.B.</i></b>: #3 is not yet implemented.
#
module Fibonaccia

  unless (Fibonaccia.const_defined?('PHI'))
    #
    # Phi (φ), the golden ratio.  φ can be simply expressed by a
    # formula, but it's an irrational number, meaning that the precision
    # is implementation-specific.
    #
    PHI			= (1.0 + Math.sqrt(5)) / 2.0
  end

  unless (::Fibonaccia.const_defined?('B') && ::Fibonaccia.const_defined?('C'))
    #
    # Constant used to construct a Golden Spiral.  See the
    # {https://en.wikipedia.org/wiki/Golden_spiral Wikipedia article}
    # for details of its definition and use.
    #
    B			= (2.0 * Math.log(PHI)) / Math::PI

    # (see B)
    C			= Math.exp(B)
  end

  #
  # Since this module is *not* intended for use as a mix-in, all the
  # methods and 'private' data are kept in the eigenclass.
  #
  class << self

    unless (const_defined?('SERIES'))
      #
      # Array of Fibonacci numbers to however many terms have been
      # evolved.  Defined as a constant because the underlying array
      # structure is mutable even for constants, and it's pre-seeded
      # with the first three terms.
      #
      SERIES		= [ 0, 1, 1 ]

      #
      # Minimum number of terms in the series -- the seed values.
      #
      MIN_TERMS		= SERIES.count
    end

    include Enumerable

    #
    # Method invoked when a scope does an <b><tt>include Fibonaccia</tt></b>.  We
    # simply emit a warning message and do nothing else.
    #
    # @param [Module,Class] klass
    #   Object in whose scope the <tt>include</tt> appeared.
    #
    # @return [void]
    #
    def included(klass)
      warn("#warning: #{self.name} " +
           'is not intended for use as a mix-in, but it does no harm')
      return nil
    end                         # def included

    #
    # Return a copy of the current Fibonacci sequence to whatever
    # point it has been evolved.  We return a _copy_ so our actual
    # array can't be accidentally polluted by whatever the caller may
    # do to what we give it.
    #
    # <b><i>N.B.</i></b>: Since this is a duplicate of the module-internal
    # array, it can have a significant impact on memory usage if the
    # series has been extended to any great length.
    #
    # @example
    #   irb> require('fibonaccia')
    #   irb> Fibonaccia.series
    #   => [0, 1, 1]
    #   irb> Fibonaccia[10]
    #   => 55
    #   irb> Fibonaccia.series
    #   => [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
    #
    # @return [Array<Integer>]
    #   Returns the list of Fibonacci numbers as far as they've been
    #   calculated by the module.
    #
    def series
      return SERIES.dup
    end                         # def series

    # @api private
    #
    # This method is called to extend the {SERIES} array if necessary.
    #
    # @param [Integer] nterms
    #   If the value of this parameter is greater than the number of
    #   terms in the {SERIES} array, new terms are calculated until
    #   the series is long enough.
    #
    # @return [void]
    #
    def extend_series(nterms)
      nterms		= [ 0, nterms.to_i ].max
      n			= [ 0, nterms - self.terms ].max
      n.times do
        SERIES		<< (SERIES[-2] + SERIES[-1])
      end
      return nil
    end                         # def extend_series
    protected(:extend_series)

    #
    # Extend the internal series by the specified number of terms.
    #
    # @param [Integer] nterms
    #   Number of terms by which to grow the internal series.
    # @return [Integer]
    #   the number of terms in the series after the operation.
    #
    # @raise [Fibonaccia::NotPositiveInteger]
    #   if the argument isn't an integer greater than or equal to zero.
    #
    def grow(nterms)
      unless (nterms.kind_of?(Integer) && (nterms >= 0))
        msg		= 'argument must be a non-negative integer'
        raise(Fibonaccia::NotPositiveInteger, msg)
      end
      self.extend_series(self.terms + nterms)
      return self.terms
    end                         # def grow

    #
    # User-space method to shrink the internal series to the specified
    # number of terms (if it isn't already).
    #
    # @note
    #   The series <b><i>cannot</i></b> be shrunk to fewer than {MIN_TERMS} elements.
    #
    # @param [Integer] nterms
    #   Number of terms by which to shrink the internal series.
    # @return [Integer]
    #   the number of terms in the series after the operation.
    #
    # @raise [Fibonaccia::NotPositiveInteger]
    #   if the argument isn't an integer greater than or equal to zero.
    #
    def shrink(nterms)
      unless (nterms.kind_of?(Integer) && (nterms >= 0))
        msg		= 'argument must be a non-negative integer'
        raise(Fibonaccia::NotPositiveInteger, msg)
      end
      nterms		= [ MIN_TERMS, self.terms - nterms ].max
      SERIES.replace(SERIES.take(nterms))
      return self.terms
    end                         # def shrink

    #
    # Similar to the #count method provided by the <tt>Enumerable</tt>
    # mix-in, but a more direct approach -- and complementary to
    # #terms=
    #
    # @return [Integer]
    #   number of terms in the internal series.
    #
    def terms
      result		= SERIES.count
      return result
    end                         # def terms

    #
    # Set the internal series to a specific number of terms.
    #
    # @note
    #   The series <b><i>cannot</i></b> be set to fewer than {MIN_TERMS} elements.
    #
    # @param [Integer] nterms
    #   Number of terms to which the series should be grown or shrunk.
    # @return [Integer]
    #   the number of terms in the series after the operation.
    #
    # @raise [Fibonaccia::NotPositiveInteger]
    #   if the argument isn't an integer greater than or equal to zero.
    #
    def terms=(nterms)
      unless (nterms.kind_of?(Integer) && (nterms >= 0))
        msg		= 'argument must be a non-negative integer'
        raise(Fibonaccia::NotPositiveInteger, msg)
      end
      nterms		= [ MIN_TERMS, nterms ].max
      if (nterms > self.terms)
        self.grow(nterms - self.terms)
      elsif (nterms < self.terms)
        self.shrink(self.terms - nterms)
      end
      return self.terms
    end                         # def terms=

    #
    # Reset our internal series to just the seed value.  This can be
    # used to free up memory.
    #
    # @return [void]
    #
    def reset
      SERIES.replace([ 0, 1, 1 ])
      return nil
    end                         # def reset

    #
    # Provide the iterator required by the <tt>Enumerable</tt> mix-in.  Walk
    # through the series and yield each value in turn.
    #
    # @yield o
    #   Each element of the currently-evolved series is yielded in turn.
    #
    # @return [Array]
    #
    def each(&block)
      result		= SERIES.each(&block)
      return result
    end                         # each

    #
    # Return the last value in the sequence so far calculated.  This
    # method is *not* part of <tt>Enumerable</tt>, so we add it explicitly.
    #
    # @return [Integer]
    #   The last value in the Fibonacci series as so far evolved.
    #
    def last
      result		= SERIES.last
      return result
    end                         # def last

    #
    # Return a slice (see Array#slice) of the Fibonacci series.
    #
    # The internal {SERIES} array will be extended, if necessary, to
    # include all terms requested.
    #
    # @param [Integer] first_term
    #   The first term of the slice from the series.
    #   <b><i>N.B.</i></b>: The series is *zero-based!*
    # @param [Integer] nterms
    #   The number of elements in the slice to be returned.
    #
    # @return [nil]
    #   if the slice parameters are not meaningful (<i>e.g.</i>, <tt>slice(1, -1)</tt>).
    # @return [Integer]
    #   if the result is a valid slice containing only one term
    #   (_i.e._, <tt>nterms</tt> is 1).  Returns the Fibonacci term at
    #   the specified (zero-based) position in the sequence.
    # @return [Array<Integer>]
    #   if the result is a valid multi-element slice (<i>e.g.</i>, <tt>nterms</tt>
    #   is greater than 1).  Returns the specified slice.
    #
    # @raise [ArgumentError]
    #   if the arguments are not all integers.
    #
    def slice(first_term, nterms=1)
      args		= {
        'first_term'	=> first_term,
        'nterms'	=> nterms,
      }
      #
      # Sanity-check our arguments; be more informative than the default
      #
      #    TypeError: no implicit conversion of <class> into Integer
      #
      args.each do |argname,argval|
        unless (argval.kind_of?(Integer))
          raise(ArgumentError, "#{argname} must be an integer")
        end
      end
      nterms		= [ 1, nterms ].max
      if (first_term < 0)
        endpoint	= [ 0, self.terms + first_term + nterms ].max
      else
        endpoint	= first_term + nterms
      end
      Fibonaccia.extend_series(endpoint)
      #
      # We're going to pass this along to the array's own #slice
      # method, so build its argument list appropriately.
      #
      args		= [ first_term ]
      args		<< nterms unless (nterms == 1)
      result		= SERIES.slice(*args)
      #
      # If we got a multi-element slice, make sure we don't return our
      # master sequence!  Ruby shouldn't let it happen, but defensive
      # programing is all.
      #
      result		= result.dup if (result === SERIES)
      return result
    end

    # @!method [](first_term, nterms=1)
    #
    # <tt>\#[]</tt> is an alias for {slice}, but <tt>Module</tt>
    # doesn't have `#alias_method`.
    #
    # This is included because it's probably more human-readable to
    # find the *n*-th term of the sequence using the syntax
    #
    #     Fibonaccia[n]
    #
    # @param (see #slice)
    # @return (see #slice)
    #
    define_method(:[], self.instance_method(:slice))

    #
    # Check to see if a given value is found in the Fibonacci series.
    # Unfortunately we need to iterate and extend our internal series
    # because of precision issues; the elegant mechanism described in
    # the 'see also' doesn't work when there are too many digits
    # involved.  Ruby loses track of them.
    #
    # @see https://en.wikipedia.org/wiki/Fibonacci_number#Recognizing_Fibonacci_numbers
    #
    # @param [Object] val
    #    Value to be checked for membership in the Fibonacci series.
    #
    # @return [Boolean]
    #    <tt>true</tt> if the given value is a Fibonacci number, else <tt>false</tt>.
    #
    def is_fibonacci?(val)
      #
      # Needs to be an integer.
      #
      return false if (! val.kind_of?(Integer))
      #
      # Needs to be non-negative.
      #
      return false if (val < 0)
      #
      # See if we've already derived the value and it's in our list (quick lookup).
      #
      while (true)
        return true if (SERIES.include?(val))
        break if (SERIES.last >= val)
        self.grow(10)
      end
      #
      # We break out when we've extended the series past the value
      # being tested.  If it was in the series, we would have already
      # returned <tt>true</tt> and not gotten here.
      #
      return false
    end                         # is_fibonacci?

  end                           # module Fibonaccia eigenclass

end                             # module Fibonaccia
