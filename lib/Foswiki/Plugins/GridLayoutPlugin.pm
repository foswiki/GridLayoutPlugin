# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# GridLayoutPlugin is Copyright (C) 2015 Michael Daum http://michaeldaumconsulting.com
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

our $VERSION = '1.00';
our $RELEASE = '1.00';
our $SHORTDESCRIPTION = 'A 12er grid system for responsive layouts';
our $NO_PREFS_IN_TOPIC = 1;
our $core;

sub core {
  unless (defined $core) {
    require Foswiki::Plugins::GridLayoutPlugin::Core;
    $core = new Foswiki::Plugins::GridLayoutPlugin::Core();
  }
  return $core;
}

sub initPlugin {

  Foswiki::Func::registerTagHandler('BEGINGRID', sub { return core->BEGINGRID(@_); });
  Foswiki::Func::registerTagHandler('ENDGRID', sub { return core->ENDGRID(@_); });
  Foswiki::Func::registerTagHandler('BEGINROW', sub { return core->BEGINROW(@_); });
  Foswiki::Func::registerTagHandler('ENDROW', sub { return core->ENDROW(@_); });
  Foswiki::Func::registerTagHandler('BEGINCOL', sub { return core->BEGINCOL(@_); });
  Foswiki::Func::registerTagHandler('ENDCOL', sub { return core->ENDCOL(@_); });

  $core = undef;

  return 1;
}

1;
