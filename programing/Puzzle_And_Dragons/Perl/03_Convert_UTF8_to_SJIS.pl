use utf8;
use warnings;
use strict;
use Encode qw/decode encode/;

my $ROOT_DNAME = $ARGV[0];

chdir("${ROOT_DNAME}");
opendir(DIR, ".") or die "Error!!";
my @d_list = readdir(DIR);

closedir(DIR);
foreach my $elem (@d_list)
{
    next if ($elem =~ /^\.{1,2}$/);
    next if ($elem !~ /PDMonster\d+$/);
    my $JSON_F = sprintf("%s\\%s.json", $elem, $elem);
    next if (! -e "$JSON_F");
    print "JSON : $JSON_F\n";
    my $JSON_SJIS = sprintf("%s\\%s_sjis.json", $elem, $elem);
    open(OF, "> $JSON_SJIS") or die "Error!!";
    open(F, "< $JSON_F") or die "Error!!!";
    while(my $LINEDATA = <F>)
    {
        chomp($LINEDATA);
        my $LINEDATA_UTF8 = decode('utf8', $LINEDATA);
        my $LINEDATA_SJIS = encode('Shift_JIS', $LINEDATA_UTF8);
        print OF $LINEDATA_SJIS, "\n";
    }
    close(F);
    close(OF);
}