use utf8;
use JSON;
use File::Slurp;

my $JSON_FILE = $ARGV[0];

&get_json_contents($JSON_FILE);

sub get_json_contents {
    my ($fname) = @_;

    my $json_data = File::Slurp::read_json_file($fname);
    my $json = JSON::decode_json($json_data);
}