source('https://rubygems.org/')

#
# All the dependencies *were* in fibonaccia.gemspec, but Bundler is
# remarkably stupid about gems needed *by* the gemspec.
#
#gemspec

RUBY_ENGINE	= 'ruby' unless (defined?(RUBY_ENGINE))

group(:default, :development, :test) do
  gem('bundler',	'>= 1.0.7')
  gem('bigdecimal')
  gem('versionomy',	'>= 0.4.4')
  #
  # This is obnoxious; it'd be better to do a
  #   if :platform >= :mri_20  # (pseudocode)
  # and not have to maintain explicit versions moving forward.
  #
  if (RUBY_VERSION < '2.0.0')
    platforms(:mri_18) do
      gem('ruby-debug',	'>= 0')
    end
    platforms(:mri_19) do
      gem('debugger',	'>= 0')
    end
  else
    gem('byebug',	'>= 0')
  end

  gem('fibonaccia',
      :path		=> '.')
end

group(:test, :development) do
  gem('aruba')
  gem('coveralls',
      :require		=> false)
  gem('rake')
  gem('simplecov',
      :require		=> false)
  gem('rdiscount')
  gem('redcarpet',	'< 3.0.0')
  gem('rdoc')
  gem('yard',		'~> 0.9.11')
end
