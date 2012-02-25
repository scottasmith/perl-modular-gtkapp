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

use File::Find;

# Test if a name is already in the array
sub name_in_array
{
	my $search_name = shift;
	my @arr = shift;
	my $i;

	for( $i = 0; $i < @arr; $i++ ) {
		if( $arr[$i]{name} eq $search_name ) {
			return $i;
		}
	}

	return -1;
}

sub include_modules
{
	use lib $APP{APP_DIR} . "/modules";
	$APP{MODULES} = [];

	find(sub {
		include_module_file($File::Find::name) if(/\.module$/);
	}, "modules"); #custom subroutine find, parse $dir
}

sub include_module_file
{
	my $file = shift;

	no strict 'refs';

	require($APP{APP_DIR} . '/' . $file);

	# Strip out leading modules and .module
	$file =~ s/modules//;
	$file =~ s/\///;
	$file =~ s/.module//;

	my %header = &{$file}();

	push @{$APP{MODULES}}, \%header;
}

1;  # To make sure that we return TRUE statement
