use strict;
use warnings;
use File::Path;
use File::Find;

my	$SRCROOT	=	$ARGV[0];

my	$INCLUDEDIR	=	"$SRCROOT\\include";

my	@D_LIB_ARR	=	();
my	@R_LIB_ARR	=	();

find( \&MAKE_LIB_HDR, $SRCROOT );

sub	MAKE_LIB_HDR {
	
	#print "$_ ( $File::Find::dir )\n";
	my	$libname	=	$_;
	
	# Debug—p‚ÆRelease—p‚É•ª‚¯‚é
	if ( $libname =~ /\.lib$/ ) {
		if ( $libname =~ /d\.lib$/ ) {
			push(@D_LIB_ARR, $libname);
		} else {
			push(@R_LIB_ARR, $libname);
		}
	}
	
}

open(HPP, "> $INCLUDEDIR\\add_libs.hpp") or die "Error!!!";
print HPP "#if _DEBUG\n";
foreach my $d_lib (@D_LIB_ARR) {
	print "$d_lib\n";
	print HPP "#pragma comment( lib, ";
	print HPP "$d_lib";
	print HPP " )\n";
}
print HPP "#else\n";
foreach my $r_lib (@R_LIB_ARR) {
	print "$r_lib\n";
	print HPP "#pragma comment( lib, ";
	print HPP "$r_lib";
	print HPP " )\n";
}
print HPP "#endif\n";
close(HPP);
