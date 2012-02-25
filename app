#!/usr/bin/perl

# Copyright (C) <2011>  <Scott Smith> <smitherz82@gmail.com>
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;
use File::Basename;
use Scalar::Util 'reftype';
use Data::Dumper;
use File::Basename;
use lib dirname(__FILE__);

#
# GLOBAL DEFINES
#
our %APP = ();
$APP{DEBUG} = 0;
$APP{APP_DIR} = dirname(__FILE__) eq '.' ? `pwd` : dirname(__FILE__);
$APP{APP_DIR} =~ s/\n//;
$APP{QUIT} = 0;

chdir $APP{APP_DIR} if $APP{APP_DIR};

# Include our libraries
#
require "lib/modules.pl";
require "lib/window.pl";

# No buffering
$| = 1;

include_modules();
create_main_window();

# Start the app
$APP{MAIN_WINDOW}->show();

while ($APP{QUIT} == 0) {
	while (Gtk2->events_pending()) {
		Gtk2->main_iteration();
	}
	# Other stuff here
}

#Gtk2->main();

# Exit main program
exit;

