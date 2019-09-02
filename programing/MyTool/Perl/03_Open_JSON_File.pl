use utf8;
use JSON;
use File::Slurp;
use Encode qw/encode decode/;

# my $JSON_FILE = $ARGV[0];
my $JSON_DIR = $ARGV[0];

# my $JSON_DATA = &get_json_contents($JSON_FILE);

# print encode('Shift_JIS', $JSON_DATA->{name});
# print "\n";
# print encode('Shift_JIS', $JSON_DATA->{parameters}->{HP}->{最大});

sub get_json_contents {
    my ($fname) = @_;

    print "File : $fname\n";

    my $json_data = File::Slurp::read_file($fname);
    my $json = JSON::decode_json($json_data);

    return ($json);
}

sub MAIN {
    my ($DIRPATH) = @_;

    opendir(DIR, "$DIRPATH") or die "Error!!";
    my @dir_list = readdir(DIR);

    foreach my $subd (@dir_list) {
        next if ($subd =~ /^\.+$/);
        next if ($subd !~ /PDMonster\d+/);
        print "$subd\n";
    }
    closedir(DIR);
}

&MAIN($JSON_DIR);