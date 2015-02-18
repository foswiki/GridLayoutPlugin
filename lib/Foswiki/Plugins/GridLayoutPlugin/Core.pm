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

package Foswiki::Plugins::GridLayoutPlugin::Core;

use strict;
use warnings;

use Foswiki::Func ();
use Error qw(:try);
use Foswiki::Plugins::GridLayoutPlugin::Grid ();

use constant TRACE => 0; # toggle me

sub writeDebug {
  Foswiki::Func::writeDebug("GridLayoutPlugin::Core - $_[0]") if TRACE;
}

sub inlineError {
  my $msg = shift;

  $msg =~ s/ at .*$//;
  return "<div class='foswikiAlert'>$msg</div>";
}

sub new {
  my $class = shift;

  my $this = bless({
    @_
  }, $class);

  $this->{stack} = [];
  $this->{doneCss} = 0;

  return $this;
}

sub pushGrid {
  my ($this, $grid) = @_;

  push @{$this->{stack}}, $grid;

  return $grid;
}

sub popGrid {
  my $this = shift;

  my $grid = pop @{$this->{stack}};
  throw Error::Simple("outside of grid") unless $grid;
 
  return $grid;
}

sub currentGrid {
  my $this = shift;

  my $grid = $this->{stack}[-1];
  throw Error::Simple("outside of grid") unless $grid;

  return $grid;
}

sub addCss {
  my $this = shift;

  return if $this->{doneCss};
  $this->{doneCss} = 1;

Foswiki::Func::addToZone('head', 'GRIDLAYOUT', <<HERE);
<link rel='stylesheet' href='%PUBURL%/%SYSTEMWEB%/GridLayoutPlugin/grid.css' media='all' />
HERE
}

sub BEGINGRID {
  my ($this, $session, $params, $topic, $web) = @_;

  my $result = '';

  $this->addCss;

  try {
    my $grid = new Foswiki::Plugins::GridLayoutPlugin::Grid();
    $this->pushGrid($grid);
    $result = $grid->begin($params);
  } catch Error::Simple with {
    $result = inlineError(shift);
  };

  return $result,
}

sub ENDGRID {
  my ($this, $session, $params, $topic, $web) = @_;

  my $result = '';

  try {
    $result = $this->popGrid->end;
  } catch Error::Simple with {
    $result = inlineError(shift);
  };

  return $result,
}

sub BEGINROW {
  my ($this, $session, $params, $topic, $web) = @_;

  my $result = '';

  try {
    $result = $this->currentGrid->beginRow($params);
  } catch Error::Simple with {
    $result = inlineError(shift);
  };

  return $result;
}

sub ENDROW {
  my ($this, $session, $params, $topic, $web) = @_;

  my $result = '';

  try {
    $result = $this->currentGrid->endRow;
  } catch Error::Simple with {
    $result = inlineError(shift);
  };

  return $result;
}

sub BEGINCOL {
  my ($this, $session, $params, $topic, $web) = @_;

  my $result = '';

  try {
    $result = $this->currentGrid->beginCol($params);
  } catch Error::Simple with {
    $result = inlineError(shift);
  };

  return $result;
}

sub ENDCOL {
  my ($this, $session, $params, $topic, $web) = @_;

  my $result = '';

  try {
    $result = $this->currentGrid->endCol;
  } catch Error::Simple with {
    $result = inlineError(shift);
  };

  return $result;
}

1;
