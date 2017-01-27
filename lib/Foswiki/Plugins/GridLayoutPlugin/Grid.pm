# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# GridLayoutPlugin is Copyright (C) 2015-2017 Michael Daum http://michaeldaumconsulting.com
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

package Foswiki::Plugins::GridLayoutPlugin::Grid;

use strict;
use warnings;

use Foswiki::Func ();
use Error qw(:try);

use constant TRACE => 0; # toggle me

sub writeDebug {
  Foswiki::Func::writeDebug("GridLayoutPlugin::Grid - $_[0]") if TRACE;
}

sub new {
  my $class = shift;

  my $this = bless({
    classes => {
      grid =>  $Foswiki::cfg{GridLayoutPlugin}{GridClass} || "foswikiGrid", 
      row =>   $Foswiki::cfg{GridLayoutPlugin}{RowClasses} || "foswikiRow",
      col =>      $Foswiki::cfg{GridLayoutPlugin}{ColClass} || "foswikiCol",
      colSize =>  $Foswiki::cfg{GridLayoutPlugin}{ColSizeClass} || "foswikiCol%n",
      offset =>  $Foswiki::cfg{GridLayoutPlugin}{OffsetClass} || "foswikiOffset%n",
      push =>  $Foswiki::cfg{GridLayoutPlugin}{PushClass} || "foswikiPush%n",
      pull =>  $Foswiki::cfg{GridLayoutPlugin}{PullClass} || "foswikiPull%n",
      gutter =>   $Foswiki::cfg{GridLayoutPlugin}{GutterClass} || "foswikiGutter%n",
      border =>   $Foswiki::cfg{GridLayoutPlugin}{BorderClass} || "foswikiBorder",
    },
    border => 0,
    gutter => 4,
    insideRow => 0,
    insideCol => 0,
    rowWidth => 0,

    @_
  }, $class);

  return $this;
}

sub begin {
  my ($this, $params) = @_;

  $this->{border} = Foswiki::Func::isTrue($params->{border}, 0);
  my $class = $params->{class} ? ' '.$params->{class}:'';
  my $style = $params->{style} ? " style='".$params->{style}."'":'';

  my $gutter = $params->{gutter};
  $gutter = 4 unless defined $gutter;

  throw Error::Simple("illegal gutter $gutter") 
    if ($gutter =~ /[^\d]/ || $gutter < 0 || $gutter > 5);

  $this->{gutter} = $gutter;

  my $gutterClass = $this->{classes}{gutter} || '';
  $gutterClass =~ s/%n/$gutter/g;

  return "<div class='$this->{classes}{grid} $gutterClass$class'$style>";
}

sub end {
  my $this = shift;

  return $this->endRow . "</div><!-- end grid -->";
}


sub beginRow {
  my ($this, $params) = @_;

  my $insideRow = $this->{insideRow};
  my $result = $this->endRow;
  my $class = $params->{class} ? ' '.$params->{class}:'';
  my $style = $params->{style} ? " style='".$params->{style}."'":'';

  my $border = Foswiki::Func::isTrue($params->{border}, $this->{border});
  $result .= '<hr />' if $border && $insideRow;
  $result .= "<div class='$this->{classes}{row}$class'$style>";

  $this->{rowWidth} = 0;
  $this->{insideRow} = 1;

  return $result;
}

sub endRow {
  my $this = shift;

  my $result = $this->endCol;

  $result .= "</div><!-- end row -->" if $this->{insideRow};

  $this->{insideRow} = 0;
  $this->{rowWidth} = 0;

  return $result;
}

sub beginCol {
  my ($this, $params) = @_;

  my $offset = $params->{offset} || 0;

  throw Error::Simple("illegal offset: $offset") 
    if ($offset =~ /[^\d]/ || $offset < 0 || $offset > 12);

  my $width = $params->{_DEFAULT} || $params->{width};
  $width = 12 - $this->{rowWidth} - $offset unless defined $width;

  throw Error::Simple("illegal width: $width") 
    if ($width =~ /[^\d]/ || $width < 1 || $width > 12);

  my $class = $params->{class} ? ' '.$params->{class}:'';
  my $border = Foswiki::Func::isTrue($params->{border}, $this->{border}) ? ' '.$this->{classes}{border}: '';
  my $style = $params->{style} ? " style='".$params->{style}."'":'';

  # close previous col
  my $result = $this->endCol;

  # auto-close previous row
  if ($this->{rowWidth} == 12 || $this->{rowWidth} + $width + $offset > 12) {
    $result .= $this->endRow;
    $result .= '<hr />' if $border ne '';
  }

  # auto-open a new row
  $result .= $this->beginRow unless $this->{insideRow};

  # add new col
  $width = 12 - $this->{rowWidth} - $offset if ($this->{rowWidth} + $width + $offset > 12);

  $this->{rowWidth} += $width;
  $this->{rowWidth} += $offset;


  $this->{insideCol} = 1;
  my $colSizeClass = $this->{classes}{colSize};
  $colSizeClass =~ s/%n/$width/g;

  my $offsetClass = $offset?" $this->{classes}{offset}":"";
  $offsetClass =~ s/%n/$offset/g;

  my $push = $params->{push} || 0;

  throw Error::Simple("illegal push: $push") 
    if ($push =~ /[^\d]/ || $push < 0 || $push > 12);

  my $pushClass = $push?" $this->{classes}{push}":"";
  $pushClass =~ s/%n/$push/g;

  my $pull = $params->{pull} || 0;

  throw Error::Simple("illegal pull: $pull") 
    if ($pull =~ /[^\d]/ || $pull < 0 || $pull > 12);

  my $pullClass = $pull?" $this->{classes}{pull}":"";
  $pullClass =~ s/%n/$pull/g;

  $result .= "<div class='$this->{classes}{col} $colSizeClass$offsetClass$pushClass$pullClass$border$class'$style>";

  return $result;
}

sub endCol {
  my $this = shift;

  my $result = "";

  $result .= "</div><!-- end col -->" if $this->{insideCol};

  $this->{insideCol} = 0;

  return $result;
}


1;
