%global	gem_name	fibonaccia
#%global gems_dir	%(ruby -rubygems -e 'begin ; puts(Gem::RUBYGEMS_DIR) ; rescue ; puts(Gem::dir) ; end' 2>/dev/null)
#%global gem_instdir	%{gem_dir}/gems/%{gem_name}-%{version}
%global	rubyabi		1.8

Name:		rubygem-%{gem_name}
Version:	0.0.1
Release:	1%{?dist}
BuildArch:	noarch

Summary:	A very basic level-or-mask status logger.

Group:		Development/Languages

License:	Apache 2.0
URL:		https://github.com/RoUS/fibonaccia
Source0:	https://rubygems.org/downloads/%{gem_name}-%{version}.gem

BuildRequires:	rubygems-devel
BuildRequires:	ruby(rubygems) >= 1.3.6


%description
This provides a simple module for dealing with the Fibonacci
series and things that relate to it.


%package doc
Summary:	Documentation for %{name}
Group:		Documentation
Requires:	%{name} = %{version}-%{release}
BuildArch:	noarch


%description doc
Documentation for %{name}


%prep
gem unpack %{SOURCE0}
%setup -q -D -T -n %{gem_name}-%{version}
gem spec %{SOURCE0} -l --ruby > %{gem_name}.gemspec


%build
gem build %{gem_name}.gemspec
#
# %%gem_install compiles any C extensions and installs the gem into
# ./%%gem_dir by default, so that we can move it into the buildroot in
# %%install
#
%gem_install


%install
mkdir -p %{buildroot}%{gem_dir}
cp -a ./%{gem_dir}/* %{buildroot}%{gem_dir}

#
# Comment these out until we know how to handle them.
#
#chmod    0644 $RPM_BUILD_ROOT%{gem_instdir}/tests/*.rb
#chmod -R 0655 $RPM_BUILD_ROOT%{gem_instdir}/features

#
# We don't need these files anymore, and they shouldn't be in the RPM.
#
rm -rf $RPM_BUILD_ROOT%{gem_instdir}/{.require_paths,.travis.yml}
rm -rf $RPM_BUILD_ROOT%{gem_instdir}/{test*,features*,rel-eng,Gemfile*}
rm -rf $RPM_BUILD_ROOT%{gem_instdir}/{Rakefile*,tasks*}
rm -rf $RPM_BUILD_ROOT%{gem_instdir}/%{name}.spec
rm -rf $RPM_BUILD_ROOT%{gem_instdir}/%{gem_name}.gemspec
rm -rf $RPM_BUILD_ROOT%{gem_cache}


#%check
#pushd .%{gem_instdir}
#ruby -S testrb -Ilib:ext/%{gem_name}/ext $(ls -1 tests/test_*.rb | sort)
#popd


%post
#
# If Yard is installed on the system, build the yri docco for the gem.
#
if which yard 2>&1 > /dev/null ; then
   yard gems %{gem_name} 2>&1 > /dev/null
fi


%files
%defattr(-,root,root,-)
%doc		%{gem_instdir}/Change[Ll]og
%doc		%{gem_instdir}/CONTRIBUTORS.md
%doc		%{gem_instdir}/LICEN[SC]E.md
%doc		%{gem_instdir}/README.md
%dir		%{gem_instdir}
%dir		%{gem_libdir}
%dir		%{gem_libdir}/%{gem_name}
%{gem_libdir}/*.rb
%{gem_libdir}/%{gem_name}/*.rb
%{gem_spec}


%files doc
%doc		%{gem_docdir}
%doc		%{gem_instdir}/[A-Z]*.html


%changelog