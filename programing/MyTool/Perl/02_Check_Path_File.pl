use strict;
use warnings;

my $FNAME = $ARGV[0];

# 拡張子を分割
my ($basename, $extention) = split(/\./, $FNAME);
#print "$basename\n";

# 環境変数Pathを取得
my $path_val = $ENV{PATH};
chomp($path_val);
#print "$path_val\n";

# セミコロン「;」で分割
my @path_arr = split(/;/, $path_val);
my $arr_sz = scalar(@path_arr);
#print "size:$arr_sz\n";

for (my $i = 0; $i < $arr_sz; $i++) {
	my $path_dir = $path_arr[$i];
	$path_dir =~ s/\\$//g;
	#print "$path_dir\n";
	my $abs_fpath = "$path_dir\\$FNAME";
	if (-e $abs_fpath) {
		print "$abs_fpath\n";
	}
	#opendir(DIR, "$path_dir") or die "Error!!";
	#my @list = readdir(DIR);
	#foreach my $f_name (@list) {
	#	next if ($f_name =~ /^\.{1,}$/);
	#	next if ($f_name !~ /${extention}$/);
	#	print "$f_name\n";
	#}
	#closedir(DIR);
}