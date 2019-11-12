# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# GridLayoutPlugin is Copyright (C) 2015-2019 Michael Daum http://michaeldaumconsulting.com
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details, published at
# http://www.gnu.org/copyleft/gpl.html

package Foswiki::Plugins::GridLayoutPlugin;

use strict;
use warnings;

use Foswiki::Func ();

our $VERSION = '3.31';
our $RELEASE = '12 Nov 2019';
our $SHORTDESCRIPTION = 'A 12er grid system for responsive layouts';
our $NO_PREFS_IN_TOPIC = 1;
our $core;

sub initPlugin {

  Foswiki::Func::registerTagHandler('BEGINGRID', sub { return getCore()->BEGINGRID(@_); });
  Foswiki::Func::registerTagHandler('ENDGRID', sub { return getCore()->ENDGRID(@_); });
  Foswiki::Func::registerTagHandler('BEGINROW', sub { return getCore()->BEGINROW(@_); });
  Foswiki::Func::registerTagHandler('ENDROW', sub { return getCore()->ENDROW(@_); });
  Foswiki::Func::registerTagHandler('BEGINCOL', sub { return getCore()->BEGINCOL(@_); });
  Foswiki::Func::registerTagHandler('ENDCOL', sub { return getCore()->ENDCOL(@_); });

  $core = undef;

  return 1;
}

sub finishPlugin {
  
}

sub getCore {
  unless (defined $core) {
    require Foswiki::Plugins::GridLayoutPlugin::Core;
    $core = Foswiki::Plugins::GridLayoutPlugin::Core->new();
  }
  return $core;
}


1;
