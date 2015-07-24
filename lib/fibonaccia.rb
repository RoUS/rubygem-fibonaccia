# -*- coding: utf-8 -*-
# @internal_comment
#
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
#

# :nocov:
if (RUBY_VERSION =~ %r!\b1.9\b!)
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end
# :nocov:

require('rubygems')
require('bundler')
Bundler.setup

require('fibonaccia/module-doc')
require('fibonaccia/version')
require('fibonaccia/exceptions')
require('bigdecimal')
require('bigdecimal/math')

module Fibonaccia

  include BigMath

  # @api private
  #
  # The number of digits of precision we want for our <tt>BigDecimal</tt> operations.
  #
  BDPrecision		= BigDecimal::double_fig

  unless (Fibonaccia.const_defined?('PHI_Float'))
    # @api private
    #
    # Phi (φ), the golden ratio.  φ can be simply expressed by a
    # formula, but it's an irrational number, meaning that the default
    # precision is implementation-specific.
    #
    # Provide a <tt>Float</tt> value which uses the default precision.
    #
    # @note
    #   Use <tt>Fibonaccia.PHI</tt> or <tt>Fibonaccia.PHI(false)</tt>
    #   to access this value.
    #
    # @see PHI
    #
    PHI_Float		= (1.0 + Math.sqrt(5)) / 2.0

    # @!macro PHIconst
    #
    #   Default value of φ as a <tt>Float</tt>.
    #
    #   Referencing <tt>PHI</tt> as a constant
    #   (<tt>Fibonaccia::PHI</tt>) is equivalent to:
    #
    #       Fibonaccia.PHI(false)
    #
    #   Use {Fibonaccia.PHI}<tt>(true)</tt> to obtain the
    #   <tt>BigDecimal</tt> representation.
    #

    # @macro PHIconst
    PHI			= PHI_Float

    # @api private
    #
    # Provide a value for φ using an arbitrarily large precision.
    #
    # @note
    #   Use <tt>Fibonaccia.PHI(true)</tt> to access this value.
    #
    # @see PHI
    #
    PHI_BigDecimal	= (1.0 + BigDecimal.new(5).sqrt(BDPrecision)) / 2.0
  end

  #
  # This bit of jiggery-pokery exists because we don't want to expose
  # the *real* definition of PHI (which is PHI_Float) in the
  # documentation.  So we wrap a fake one in a never-successful
  # conditional, and Yard uses that.
  #
  # :nocov:
  if (false)
    # @macro PHIconst
    PHI			= calculated_constant
  end
  # :nocov:

  unless (::Fibonaccia.const_defined?('B_Float'))
    # @!macro SpiralFactors
    #   Constant used to construct a Golden Spiral.  See the
    #   {https://en.wikipedia.org/wiki/Golden_spiral Wikipedia article}
    #   for details of its definition and use.

    # @api private
    #
    # @macro SpiralFactors
    #
    # This constant is a <tt>Float</tt> value.  For greater precision,
    # use {B_BigDecimal}.
    #
    B_Float		= (2.0 * Math.log(PHI_Float)) / Math::PI

    # @api private
    #
    # @macro SpiralFactors
    #
    # This constant is a <tt>BigDecimal</tt> value.  If you don't need
    # arbitrarily great precision, use {B_BigDecimal} instead.
    #
    B_BigDecimal	= ((2.0 * BigMath.log(PHI_BigDecimal, BDPrecision)) / BigMath.PI(BDPrecision))

    # (see B_Float)
    C_Float		= Math.exp(B_Float)

    # (see B_BigDecimal)
    C_BigDecimal	= BigMath.exp(B_BigDecimal, BDPrecision)
  end

  #
  # Since this module is *not* intended for use as a mix-in, all the
  # methods and 'private' data are kept in the eigenclass.
  #
  class << self

    include BigMath

    unless (const_defined?('SERIES'))
      #
      # First three terms of the Fibonacci sequence, which is our seed
      # and our minimum internal series.
      #
      SEED		= [ 0, 1, 1 ].freeze

      # @api private
      #
      # Minimum number of terms in the series -- the seed values.
      #
      MIN_TERMS		= SEED.count

      # @api private
      #
      # Array of Fibonacci numbers to however many terms have been
      # evolved.  Defined as a constant because the underlying array
      # structure is mutable even for constants, and it's pre-seeded
      # with the first three terms.
      #
      SERIES		= SEED.dup
    end

    include Enumerable

    # @private
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
    # Constant Phi (φ), the golden ratio.
    #
    # φ can be simply expressed by a formula, but it's an irrational
    # number, meaning that the default precision is
    # implementation-specific.  {PHI} allows you to access the value
    # either at the implementation precision, or the
    # <tt>BigDecimal</tt> extended precision.
    #
    # @!macro PHIdoc
    #   @param [Boolean] extended
    #
    #   @return [Float]
    #     when <tt>extended</tt> is false (or at least not a true value).
    #   @return [BigDecimal]
    #     when <tt>extended</tt> is true.
    #
    #   @example Using conventional 'constant' semantics
    #       irb> Fibonaccia::PHI
    #       => 1.618033988749895
    #       irb> Fibonaccia::PHI(false)
    #       => 1.618033988749895
    #       irb> Fibonaccia::PHI(true)
    #       => #<BigDecimal:198e990,'0.1618033988 7498948482 0458683433 33333335E1',54(72)>
    #
    #   @example Using module method semantics
    #       irb> Fibonaccia.PHI
    #       => 1.618033988749895
    #       irb> Fibonaccia.PHI(false)
    #       => 1.618033988749895
    #       irb> Fibonaccia.PHI(true)
    #       => #<BigDecimal:198e990,'0.1618033988 7498948482 0458683433 33333335E1',54(72)>
    #
    # @macro PHIdoc
    #
    def PHI(extended=false)
      result		= (extended \
                           ? PHI_BigDecimal \
                           : PHI_Float)
      return result
    end                         # def PHI

    # @internal_comment
    #
    # I can't get Yard to process the phi as a method name, so it's
    # just undocumented.  Meh.
    #

    # @api private
    #
    # Alias name (probably not universally useable) for the {PHI} method.
    #
    # @macro PHIdoc
    #
    define_method(:'φ', self.instance_method(:PHI))

    # @api private
    #
    # We return a <i>copy</i> so our actual array can't be accidentally
    # polluted by whatever the caller may do to what we give it.
    #

    #
    # Copy of the internal series.
    #
    # Return a <tt>dup</tt> of the internal series, to however many
    # terms it has grown.
    #
    # @note
    #   Since this is a duplicate of the module-internal array, it can
    #   have a significant impact on memory usage if the series has
    #   been extended to any great length.
    #
    # @see reset
    # @see shrink
    # @see terms=
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
    #   Total number of terms required to be in the series.  If the
    #   value of this parameter is greater than the number of terms in
    #   the {SERIES} array, new terms are calculated until the series
    #   is long enough.
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
    # @note
    #   Passing a negative number to #grow is equivalent to to using #shrink.
    #
    # @see shrink
    # @see terms=
    #
    # @raise [Fibonaccia::NotInteger]
    #   if the argument isn't an Integer.
    #
    def grow(nterms)
      unless (nterms.kind_of?(Integer))
        msg		= 'argument must be an integer'
        raise(Fibonaccia::NotInteger, msg)
      end
      self.terms	= [ MIN_TERMS, self.terms + nterms ].max
      return self.terms
    end                         # def grow

    #
    # Shrink the internal series by the specified number of terms.
    #
    # @!macro minsize
    #   @note
    #     The series <b><i>cannot</i></b> be shrunk to fewer than the
    #     {SEED} elements.
    #
    # @macro minsize
    # @param [Integer] nterms
    #   Number of terms by which to shrink the internal series.
    # @return [Integer]
    #   the number of terms in the series after the operation.
    #
    # @note
    #   Passing a negative number to #shrink is equivalent to to using #grow.
    #
    # @see grow
    # @see terms=
    #
    # @raise [Fibonaccia::NotInteger]
    #   if the argument isn't an Integer value.
    #
    def shrink(nterms)
      unless (nterms.kind_of?(Integer))
        msg		= 'argument must be an integer'
        raise(Fibonaccia::NotInteger, msg)
      end
      self.terms	= [ MIN_TERMS, self.terms - nterms ].max
      return self.terms
    end                         # def shrink

    #
    # The number of terms in the internal series.
    #
    # Similar to the #count method provided by the <tt>Enumerable</tt>
    # mix-in, but a more direct approach -- and complementary to
    # the {terms=} method.
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
    # @macro minsize
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
        self.extend_series(nterms)
      elsif (nterms < self.terms)
        SERIES.replace(SERIES.take(nterms))
      end
      return self.terms
    end                         # def terms=

    #
    # Reset the internal series to just the seed value.
    #
    # This can be used to free up memory.
    #
    # @return [void]
    #
    def reset
      SERIES.replace(SEED)
      return nil
    end                         # def reset

    #
    # Iterate over the current internal series, yielding each value in
    # turn.
    #
    # @yield [Integer]
    #   Each element of the internal series is yielded in turn.
    #
    # @return [Array<Integer>]
    #   if a block has been passed.
    # @return [Enumerator]
    #   when invoked without a block.
    #
    def each(&block)
      result		= SERIES.each(&block)
      return result
    end                         # each

    # @internal_comment
    #
    # The following method is *not* part of <tt>Enumerable</tt>, so we
    # add it explicitly.
    #

    #
    # Return the last value in the internal series.
    #
    # This is equivalent to
    #
    #     Fibonaccia[-1]
    #
    # @return [Integer]
    #   the last term in the internal series.
    #
    def last
      result		= SERIES.last
      return result
    end                         # def last

    #
    # Obtain a slice (see Array#slice) of the Fibonacci series.
    #
    # The internal series will be extended, if necessary, to include
    # all terms requested.
    #
    # @note
    #   The internal series is *zero-based*, which means the first
    #   term is numbered <tt>0</tt>.
    #
    # @param [Integer] first_term
    #   The first term of the slice from the series.
    # @param [Integer] nterms
    #   The number of elements in the slice to be returned.
    #
    # @return [Integer]
    #   if the result is a valid slice containing only one term
    #   (<i>i.e.</i>, <tt>nterms</tt> is 1).  Returns the Fibonacci term at
    #   the specified (zero-based) position in the sequence.
    # @return [Array<Integer>]
    #   if the result is a valid multi-element slice (<i>e.g.</i>, <tt>nterms</tt>
    #   is greater than 1).  Returns the specified slice.
    # @return [nil]
    #   if the slice parameters are not meaningful (<i>e.g.</i>, <tt>slice(1, -1)</tt>).
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

    # @internal_comment
    #
    # <tt>Module</tt> doesn't have <tt>#alias_method</tt>, so we have
    # to work sideways to make the equivalent functionality happen.
    # And Yard doesn't pick up on <tt>define_method</tt> invocations,
    # so we have to add the method documentation manually.
    #

    # @!method [](first_term, nterms=1)
    #
    # Alias for {slice} ( *q.v.*).
    #
    # This is included because it's probably more human-readable to
    # find the *n*-th term of the sequence using the syntax
    #
    #     Fibonaccia[n]
    #
    # @see slice
    #
    define_method(:[], self.instance_method(:slice))

    # @internal_comment
    #
    # We need to use the <tt>BigDecimal</tt> module to deal with the
    # extra precision required for #is_fibonacci?.
    #
    # In addition, we don't use #member? or #include? for this
    # functionality because it would onflict with the Enumerable
    # semantics for those, which apply to the internal series.
    #

    #
    # See if value appears in the Fibonacci series.
    #
    # Check to see if the given value is found in the Fibonacci series,
    # using the transform described at
    # {https://en.wikipedia.org/wiki/Fibonacci_number#Recognizing_Fibonacci_numbers}.
    #
    # @see https://en.wikipedia.org/wiki/Fibonacci_number#Recognizing_Fibonacci_numbers
    #
    # @param [Integer] val
    #    Value to be checked for membership in the Fibonacci series.
    #
    # @return [Boolean]
    #    <tt>true</tt> if the given value is a Fibonacci number, else <tt>false</tt>.
    #
    def is_fibonacci?(val)
      #
      # Needs to be an integer.
      #
      return false unless (val.respond_to?(:floor) && (val.floor == val))
      #
      # Needs to be non-negative.
      #
      return false if (val < 0)
      return true if (SERIES.include?(val))
      #
      # Easy checks are done, time for some math-fu.
      #
      val		= BigDecimal.new(val)
      [ +4, -4 ].each do |c|
        eqterm		= 5 * (val**2) + c
        root		= eqterm.sqrt(BDPrecision)
        return true if (root.floor == root)
      end
      return false
    end                         # is_fibonacci?

  end                           # module Fibonaccia eigenclass

end                             # module Fibonaccia
