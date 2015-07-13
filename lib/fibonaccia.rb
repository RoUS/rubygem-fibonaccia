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
#    (*not* the Fibonacci spiral, which is an approximation of the golden spiral), again
#    to the precision specified by the caller.
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

    #
    # As the {SERIES internally-maintained series} grows, this method allows
    # the caller to find out how many terms have been calculated so
    # far.
    #
    # @return [Integer]
    #   Returns the number of terms in the module's
    #   currently-calculated series.
    #
    def count
      return SERIES.count
    end                         # def count

    # @api private
    #
    # This method is called to extend the {SERIES} array if necessary.
    #
    # @param [Integer] terms
    #   If the value of this parameter is greater than the number of
    #   terms in the {SERIES} array, new terms are calculated until
    #   the series is long enough.
    #
    # @return [void]
    #
    def extend_series(terms)
      terms		= [ 0, terms.to_i ].max
      n			= [ 0, terms - self.count ].max
      n.times do
        SERIES		<< (SERIES[-2] + SERIES[-1])
      end
      return nil
    end                         # def extend_series
    protected(:extend_series)

    def each
      result		= SERIES.each { |o| yield(o) }
      return result
    end                         # each

    #
    # Return a slice (see Array#slice) of the Fibonacci series.
    #
    # The internal {SERIES} array will be extended, if necessary, to
    # include all terms requested.
    #
    # @param [Integer] first_term
    #   The first term of the slice from the series.
    #   <b><i>N.B.</i></b>: The series is *zero-based!*
    # @param [Integer] terms
    #   The number of elements in the slice to be returned.
    #
    # @return [nil]
    #   if the slice parameters are not meaningful (_e.g._, <tt>slice(1, -1)</tt>).
    # @return [Integer]
    #   if the result is a valid slice containing only one term
    #   (_i.e._, <tt>terms</tt> is 1).  Returns the Fibonacci term at
    #   the specified (zero-based) position in the sequence.
    # @return [Array<Integer>]
    #   if the result is a valid multi-element slice (_e.g._, <tt>terms</tt>
    #   is greater than 1).  Returns the specified slice.
    #
    # @raise [ArgumentError]
    #   if the arguments are not all integers.
    #
    def slice(first_term, terms=1)
      args		= {
        'first_term'	=> first_term,
        'terms'		=> terms,
      }
      #
      # Sanity-check our arguments; be more informative than the default
      #
      #    TypeError: no implicit conversion of <class> into Integer
      #
      args.each do |argname,argval|
        unless (argval.kind_of?(Integer))
          raise ArgumentError.new("#{argname} must be an integer")
        end
      end
      terms		= [ 1, terms ].max
      if (first_term < 0)
        endpoint	= [ 0, self.count + first_term + terms ].max
      else
        endpoint	= first_term + terms
      end
      Fibonaccia.extend_series(endpoint)
      #
      # We're going to pass this along to the array's own #slice
      # method, so build its argument list appropriately.
      #
      args		= [ first_term ]
      args		<< terms unless (terms == 1)
      result		= SERIES.slice(*args)
      #
      # If we got a multi-element slice, make sure we don't return our
      # master sequence!  Ruby shouldn't let it happen, but defensive
      # programing is all.
      #
      result		= result.dup if (result === SERIES)
      return result
    end

    # @!method [](first_term, terms=1)
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

  end                           # module Fibonaccia eigenclass

end                             # module Fibonaccia
