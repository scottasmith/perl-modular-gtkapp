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

use Gtk2 '-init';
use Glib qw/TRUE FALSE/; 

our $stay_active=0;

sub create_main_window {
	$APP{MAIN_WINDOW} = Gtk2::Window->new;
	$APP{MAIN_WINDOW}->signal_connect('delete_event' => sub { if($stay_active!=1){$APP{QUIT}=1;}else{TRUE}});
	$APP{MAIN_WINDOW}->set_position('center');
	$APP{MAIN_WINDOW}->set_size_request (400, 300);

	#add and the vbox
	$APP{MAIN_WINDOW}->add(&create_main_vbox);
}

sub pump_messages {
	while (Gtk2->events_pending()) {
		Gtk2->main_iteration();
	}
}

sub create_main_menu {
	#Start of with a Gtk2::Menu widget
	my $menu_edit = Gtk2::Menu->new();
	
	#add a check menu item	
	my $menu_item_stay_active = Gtk2::CheckMenuItem->new('_Stay Alive');
	#connect to the toggled signal to catch the active state
	$menu_item_stay_active->signal_connect('toggled' => \&main_menu_toggle_stay_alive, "Stay alive");
	$menu_edit->append($menu_item_stay_active);

	#add quit a menu item
	my $menu_item_quit = Gtk2::MenuItem->new('_Quit');
	$menu_item_quit->signal_connect('activate' => sub {$APP{QUIT}=1;}, "Quit");
	$menu_edit->append($menu_item_quit);

	#add a separator
	$menu_edit->append(Gtk2::SeparatorMenuItem->new());

	#create a menu bar with two menu items, one will have $menu_edit
	#as a submenu		
	my $menu_bar = Gtk2::MenuBar->new;

	#add a menu item
	my $menu_item_edit= Gtk2::MenuItem->new('_Application');
	#set its sub menu
	$menu_item_edit->set_submenu ($menu_edit);
			
	$menu_bar->append($menu_item_edit);

	#add a menu item
	my $menu_item_help = Gtk2::MenuItem->new('_Help');
	$menu_item_help->set_right_justified(TRUE);
	$menu_item_help->signal_connect('activate' => sub { msg_dialog('Dude, Really!'); }, "Help");
	  
	$menu_bar->append($menu_item_help);	

	return $menu_bar;
}

sub create_main_vbox {
	my $menu = &create_main_menu;

	my $vbox = Gtk2::VBox->new(FALSE,5);
	my $nb = &create_main_notebook;
	$nb->show_all;
	
	$vbox->pack_start($menu,FALSE,FALSE,0);
	$vbox->pack_end($nb,TRUE,TRUE,0);
	$vbox->show_all;
	return $vbox;
}

sub create_main_notebook {
	my $vbox_nb = Gtk2::VBox->new(TRUE,5);
	$vbox_nb->set_border_width(5);
	$vbox_nb->set_size_request (500, 300);

	my $nb = Gtk2::Notebook->new;
	
	#pre-set some properties
	$nb->set_scrollable (TRUE); 
	$nb->set_tab_pos('left');

	my @modules = sort {
			$$a{rank} <=> $$b{rank};
		} @{$APP{MODULES}};

	foreach(@modules) {
		my %module = %{$_};
		create_tab($nb, $module{menu_title}, $module{frame});
	}

	$vbox_nb->pack_start($nb,TRUE,TRUE,0);
	return $vbox_nb;
}


sub create_tab {
	my ($nb,$title,$frame) = @_;
	my $child = $frame || Gtk2::Label->new('Boom!');;
	my $lbl=Gtk2::Label->new($title);

	$nb->append_page ($child,$lbl); 
}

################################################
# Menu Callbacks
##
sub main_menu_toggle_stay_alive {
	my ($menu_item,$text) = @_;
	my $val = $menu_item->get_active;
	($val)&&($stay_active=1);
	($val)||($stay_active=0);
}

################################################
# Misc
##
sub msg_dialog {
	my $msg_txt = shift;
	my $dialog = Gtk2::MessageDialog->new ($APP{MAIN_WINDOW},'destroy-with-parent','info','ok',$msg_text);
	$dialog->run;
	$dialog->destroy;
}

1;  # To make sure that we return TRUE statement
