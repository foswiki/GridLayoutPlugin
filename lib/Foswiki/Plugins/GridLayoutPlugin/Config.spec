# ---+ Extensions
# ---++ GridLayoutPlugin
# This is the configuration used by the <b>GridLayoutPlugin</b>.

# **STRING**
# CSS class for the grid container
$Foswiki:cfg{GridLayoutPlugin}{GridClass} = "foswikiGrid";

# **STRING**
# CSS class for grid rows
$Foswiki:cfg{GridLayoutPlugin}{RowClasses} = "foswikiRow";

# **STRING**
# CSS class for grid columns
$Foswiki:cfg{GridLayoutPlugin}{ColClass} = "foswikiCol";

# **STRING**
# CSS class to indicate the column size; %n will be replaced with values 1-12
$Foswiki:cfg{GridLayoutPlugin}{ColSizeClass} = "foswikiCol%n";

# **STRING**
# CSS class to indicate the column offset; %n will be replaced with values 0-11
$Foswiki:cfg{GridLayoutPlugin}{OffsetClass} = "foswikiOffset%n";

# **STRING**
# CSS class for the grid gutter; %n will be repalced with values 1-5 
$Foswiki:cfg{GridLayoutPlugin}{GutterClass} = "foswikiGutter%n";

# **STRING**
# CSS class for border styles added to rows and/or columns
$Foswiki:cfg{GridLayoutPlugin}{BorderClass} = "foswikiBorder";

1;
