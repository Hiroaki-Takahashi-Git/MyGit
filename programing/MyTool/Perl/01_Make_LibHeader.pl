use strict;
use warnings;
use File::Path;
use File::Find;

my	$SRCROOT	=	$ARGV[0];
my	$PREFIXNAME	=	$ARGV[1];
my	$VERSION	=	$ARGV[2];

my	$ARGC	= scalar(@ARGV);
if ( $ARGC == 0 ) {
	print "Usage;\n";
	print "$0 [Path/to/Installed/include/dir] [version]\n";
	print "Example:\n";
	print "$0 %OPENCVDIR% 4.12";
	exit(0);
}

my	$INCLUDEDIR	=	"$SRCROOT\\include";
my	$VER_STRING	=	$VERSION;

if ( $ARGC == 3 ) {
	$VER_STRING	=~	s/\.//g;
} else {
	$VER_STRING = "";
}

my	@D_LIB_ARR	=	();
my	@R_LIB_ARR	=	();

find( \&MAKE_LIB_HDR, $SRCROOT );

sub	MAKE_LIB_HDR {
	
	#print "$_ ( $File::Find::dir )\n";
	my	$libname	=	$_;
	
	# Debug—p‚ÆRelease—p‚É•ª‚¯‚é
	if ( $libname =~ /\.lib$/ ) {
		if ( $libname =~ /${VER_STRING}d\.lib$/ ) {
			push(@D_LIB_ARR, $libname);
		} elsif ( $libname =~ /${VER_STRING}\.lib$/ ) {
			push(@R_LIB_ARR, $libname);
		}
	}
	
}

my $PREFIX2 = $PREFIXNAME;
$PREFIX2 =~ s/(\w+)/\U$1/;
open(HPP, "> $INCLUDEDIR\\${PREFIXNAME}${VER_STRING}_libs.hpp") or die "Error!!!";
print HPP "#ifndef ${PREFIX2}${VER_STRING}_LIBS_HPP\n";
print HPP "#define ${PREFIX2}${VER_STRING}_LIBS_HPP\n";
print HPP "\n";
print HPP "#if _DEBUG\n";
foreach my $d_lib (@D_LIB_ARR) {
	print "$d_lib\n";
	print HPP "\t#pragma comment( lib, ";
	print HPP "\"$d_lib\"";
	print HPP " )\n";
}
print HPP "#else\n";
foreach my $r_lib (@R_LIB_ARR) {
	print "$r_lib\n";
	print HPP "\t#pragma comment( lib, ";
	print HPP "\"$r_lib\"";
	print HPP " )\n";
}
print HPP "#endif\n";
print HPP "\n";
print HPP "#endif\n";
close(HPP);
