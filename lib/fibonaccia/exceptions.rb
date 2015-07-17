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

require('fibonaccia/module-doc')

module Fibonaccia

  #
  # Define a 'parent' exception class for the module.  All
  # module-specific exceptions should inherit from this.
  #
  class ::Fibonaccia::Exception < ::StandardError

    #
    # We cannot access the <tt>mesg</tt> 'instance variable' of the
    # inherited class hierarchy, do we needs must fake it as part of
    # our constructor.
    #
    # If the first element of the argument list is a string, we set
    # our message to it.  Otherwise, we follow the practice of using
    # the name of the class as the message.
    #
    # @param [Array] args
    #   <tt>::StandardError.method(:new).arity => -1</tt>, so we allow
    #   an undefined number of arguments here, as well.  We only look
    #   at the first one, though.  If it's a string, we use it --
    #   otherwise we set the message to <tt>nil</tt> and let
    #   #to_s/#to_str apply the default at need.
    #
    def initialize(*args)
      @mesg		= (args[0].respond_to?(:to_str)) ? args[0] : nil
      return super
    end                         # def initialize

    #
    # We cannot access the standard <tt>Exception</tt> hierarchical
    # message mechanism because it store the message in a
    # non-<tt>@</tt> prefixed 'instance variable.'  So we need to work
    # around it with our own instance variable, set by the
    # constructor.
    #
    # @return [String]
    #   whatever the constructor stored in the <tt>@mesg</tt> instance
    #   variable, or the class name if <tt>@mesg</tt> is <tt>nil</tt>.
    #
    def to_s
      return (@mesg || self.class.name)
    end                         # def to_s

    #
    # Having a <tt>#to_str</tt> method tells Ruby 'you can treat me as a String.'
    # This just returns the same value as #to_s.
    #
    # @return [String]
    #   value returned by #to_s method.
    #
    def to_str
      return self.to_s
    end                         # def to_str

  end                           # class Exception

  class NotPositiveInteger < ::Fibonaccia::Exception

  end                           # class NotPositiveInteger

end                             # module Fibonaccia
