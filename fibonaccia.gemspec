# -*- encoding: utf-8 -*-
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

Proc.new {
  libdir = File.join(File.dirname(__FILE__), 'lib')
  xlibdir = File.expand_path(libdir)
  $:.unshift(xlibdir) unless ($:.include?(libdir) || $:.include?(xlibdir))
}.call
require('fibonaccia/version')

Gem::Specification.new do |s|
  s.required_ruby_version = ">= #{Fibonaccia::MINIMUM_RUBY_VERSION.to_s}"
  if (s.respond_to?(:required_rubygems_version=))
    s.required_rubygems_version = Gem::Requirement.new('>= 0')
  end
  s.name          	= 'fibonaccia'
  s.version       	= Fibonaccia::VERSION
  s.authors       	= [
                           'Ken Coar',
                          ]
  s.email         	= [
                           'kcoar@redhat.com',
                          ]
  s.summary       	= ("#{'%s-%s' % [ s.name, s.version, ]} - " +
                           'Easy access to Fibonacci series and related things.')
  s.description   	= <<-EOD
Non-mixin module providing access to terms in the Fibonacci series.
Fetch specific terms, slice the series, check to see if an arbitrary
value is a Fibonacci number, etc.
  EOD
  s.homepage      	= 'https://github.com/RoUS/rubygem-fibonaccia'
  s.license       	= 'Apache 2.0'

  s.files         	= `git ls-files -z`.split("\x0")
  #
  # These cause problems when building RPMs, and we don't need 'em in
  # the gem anyway.
  #
  s.files.delete('.yardopts')
  s.files.delete('.gitignore')
  s.executables   	= s.files.grep(%r!^bin/!) { |f| File.basename(f) }
  s.test_files    	= s.files.grep(%r!^(test|spec|features)/!)
  s.has_rdoc		= true
  s.extra_rdoc_files	= [
    'README.md',
    'Details.md',
  ]
  s.rdoc_options	= [
    '--main=README.md',
    '--charset=UTF-8',
  ]
  s.require_paths 	= [
    'lib',
  ]

  #
  # Make a hash for our dependencies, since we're using some fancy
  # code to declare them depending upon the version of the
  # environment.
  #
  requirements_all	= {
    'bigdecimal'	=> [],
    'bundler'		=> [
      '~> 1.7',
    ],
    'versionomy'	=> [
      '>= 0.4.3',
    ],
  }
  requirements_dev	= {
    'cucumber'		=> [],
    'rake'		=> [
      '~> 10.0',
    ],
    'rdiscount'		=> [],
    'yard'		=> [
      '>= 0.9.11',
    ],
  }

  requirements_all.each do |dep,*vargs|
    args	= [ dep ]
    args.push(*vargs) unless (vargs.count.zero? || vargs[0].empty?)
    s.add_dependency(*args)
  end

  #
  # The following bit of hanky-panky was adapted from uuidtools-2.1.3.
  #
  if (s.respond_to?(:specification_version=))
    s.specification_version = 3

    if (Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0'))
      depmethod	= :add_development_dependency
    else
      depmethod	= :add_dependency
    end
  else
    depmethod	= :add_dependency
  end
  requirements_dev.each do |dep,*vargs|
    args	= [ dep ]
    args.push(*vargs) unless (vargs.count.zero? || vargs[0].empty?)
    s.send(depmethod, *args)
  end

end                             # Gem::Specification.new
