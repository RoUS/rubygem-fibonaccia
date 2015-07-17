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
require('versionomy')

module Fibonaccia

  #
  # Minimum version of Ruby we support.
  #
  MINIMUM_RUBY_VERSION	= Versionomy.parse('1.9.3')
  #
  # Enforce our minimum requirement.
  #
  if (Versionomy.ruby_version < MINIMUM_RUBY_VERSION)
    raise(RuntimeError,
          "minimum Ruby version required is #{MINIMUM_RUBY_VERSION.to_s}, " +
          "running #{Versionomy.ruby_version.to_s}")
  end

  #
  # Initial starting point.
  #
  @version		= Versionomy.parse('0.0.1')

  #
  # First actual release: 1.0.0!
  #
#  @version		= @version.change(:major	=> 1,
#               	                  :tiny		=> 0)

  #
  # How to advance the version number.
  #
  #@version		= @version.bump(:minor)

  @version.freeze

  #
  # Frozen string representation of the module version number.
  #
  VERSION		= @version.to_s.freeze

  #
  # Returns the {http://rubygems.org/gems/versionomy Versionomy}
  # representation of the package version number.
  #
  # @return [Versionomy]
  #
  def self.version
    return @version
  end                           # def self.version

  #
  # Returns the package version number as a string.
  #
  # @return [String]
  #   Package version number.
  #
  def self.VERSION
    return self.const_get('VERSION')
  end                           # def self.VERSION

end                             # module Fibonaccia
