#!/usr/bin/perl
use Glib qw/TRUE FALSE/;
use Gtk2 '-init';
use warnings;
use strict;

sub render_toggle_cell {
  my($tcolview,$cell,$model,$iter, $column) = @_;
#  print "$tcolview, $cell, $model, $iter, $column\n";

  my ($toggle_item) = $model->get ($iter, $column);
  
  if($toggle_item){
      $cell->set_active(1);
     }else{$cell->set_active(0)}

}

 my $window = Gtk2::Window->new('toplevel');
 $window->signal_connect(destroy => sub {Gtk2->main_quit;});
 $window->set_border_width(10);
 $window->set_title('app-keybind');
 $window->set_default_size(500,500);
my $main_box = Gtk2::VBox->new( 0, 5 );
my $vbox = Gtk2::VBox->new( 0, 5 );
my $hbox = Gtk2::HBox->new(  );

my $model = Gtk2::ListStore->new(
               			    "Glib::String",  #col0 name 
				    "Glib::String",  #col1 action
				    "Glib::String",  #col1 /key
				    "Glib::Boolean", #col5
				  );
#-------------Name column-----------------------				  

my $col_name = 0;
my $renderer_name = Gtk2::CellRendererText->new;
$renderer_name->set( editable => TRUE );
#$renderer_name->signal_connect( edited => sub { &process_editing( @_, $col_name ); } );
my $column_name = Gtk2::TreeViewColumn->new_with_attributes( "  Name   ",$renderer_name,'text' => $col_name);

#-------------Action column-----------------------				  

my $col_action = 0;
my $renderer_action = Gtk2::CellRendererText->new;
$renderer_action->set( editable => TRUE );
#$renderer_action->signal_connect( edited => sub { &process_editing( @_, $col_action); } );
my $column_action = Gtk2::TreeViewColumn->new_with_attributes( " action   ",$renderer_action,'text' => $col_action);

#-------------key column-----------------------				  

my $col_key = 0;
my $renderer_key = Gtk2::CellRendererText->new;
$renderer_key->set( editable => TRUE );
#$renderer_key->signal_connect( edited => sub { &process_editing( @_, $col_action); } );
my $column_key = Gtk2::TreeViewColumn->new_with_attributes( " key name   ",$renderer_key,'text' => $col_key);

#-------------dual_instance column-----------------------				  

my $col_double_instance = 0;
my $renderer_double_instance = Gtk2::CellRendererToggle->new();
$renderer_double_instance->set( activatable => 1 );
#$renderer_key->signal_connect( edited => sub { &process_editing( @_, $col_action); } );
my $column_double = Gtk2::TreeViewColumn->new_with_attributes( " Double Instace   ",$renderer_double_instance);
$column_double->set_resizable (TRUE);

# set initial value on display
$column_double->set_cell_data_func( $renderer_double_instance, sub { &render_toggle_cell( @_, $col_double_instance ); } );



my $treeview = Gtk2::TreeView->new( $model );

# a TreeSelection
$treeview->get_selection->set_mode ('extended');

$treeview->set_rules_hint( TRUE );

$treeview->append_column( $column_name );
$treeview->append_column( $column_action );
$treeview->append_column( $column_key );


my $sw = Gtk2::ScrolledWindow->new( undef, undef );
$sw->set_shadow_type( "etched-in" );
$sw->set_policy( "never", "always" );

$sw->add( $treeview );
  my $button = Gtk2::Button->new ('New bind');
  $hbox->pack_end( $button, 0, 0, 0 );

  $vbox->pack_start( $sw, 1, 1, 0 );
$main_box->pack_start( $vbox, 1, 1, 0 );
$main_box->pack_start( $hbox, 0, 0, 0 );
$window->add( $main_box );
#$window->add( $hbox );

$window->show_all;
Gtk2->main;
0;

