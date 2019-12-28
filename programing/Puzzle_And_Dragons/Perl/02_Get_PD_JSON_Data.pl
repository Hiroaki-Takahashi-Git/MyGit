use utf8;
use strict;
use warnings;
use Encode 'decode';
use Encode 'encode';
use JSON;
use File::Slurp;

my $ROOTDIR = $ARGV[0];

# JSONファイルのリストを作成する
sub make_json_list {
    my ($rootdir) = @_;
    my @output = ();

    # ディレクトリを開く
    opendir(DIR, "$rootdir") or die "Error!!";
    my @list = readdir(DIR);
    foreach my $fname (@list) {
        next if ($fname =~ /^\.+$/);
        next if ($fname !~ /^PDMonster\d+$/);
        my $json_path = sprintf("%s\\%s\\%s.json", $rootdir, $fname, $fname);
        next if (! -f $json_path);
        push(@output, $json_path);
    }
    closedir(DIR);

    return(@output);
}
# JSONファイルからデータを取得する
sub get_json_contents {
    my ($fname) = @_;

    my $json_data = File::Slurp::read_file($fname);
    my $json = JSON::decode_json($json_data);

    return ($json);
}
# JSONデータの中身を取得する
sub get_json_parts {
    my ($json_parent) = @_;
    my @output = ();

    my $index = 1;
    foreach my $var (sort(keys(%{$json_parent}))) {
        my $value = $$json_parent{$var};
        my $var_ref = ref($value);
        # 入れ子になっている場合は再帰的に出力する
        if ("$var_ref" eq "HASH") {
            # print "var : ", encode('Shift_JIS', "$var"), "\n";
            # $index++;
            my @output2 = &get_json_parts($value);
            for (my $i = 0; $i < scalar(@output2); $i++) {
                $output2[$i] = sprintf("%02d_%s_%s", $index, $var, $output2[$i]);
            }
            push(@output, @output2);
        } else {
           if ($value =~ /^\d+$/) {
                $value = sprintf("%06d", $value);
            }
            my $result = sprintf("%02d_%s_%s", $index, $var, $value);
            push(@output, $result);
        }
        $index++;
    }
    return(@output);
}
# ファイルに出力
sub output_result {
    my ($fname, $in_arr) = @_;
    my $arr_sz = scalar(@{$in_arr});

    open(OUT, "> $fname") or die "Error!!";
    for (my $i = 0; $i < $arr_sz; $i++) {
        print OUT "$$in_arr[$i]\n";
    }
    close(OUT);
}
# MAIN関数
sub main {
    my ($ROOTDIR) = @_;

    # リストを作成
    my @JSON_ARR = &make_json_list($ROOTDIR);

    # JSONデータを取得
    foreach my $F_PATH (@JSON_ARR) {
        # next if ($F_PATH !~ /PDMonster003388/);
        
        # JSON形式からハッシュ形式に変換
        my $JSON_DATA = &get_json_contents($F_PATH);

        # ハッシュ形式から配列形式に変換
        my @JSON_ARR = &get_json_parts($JSON_DATA);
        my @OUT_ARRAY = ();
        for (my $i = 0; $i < scalar(@JSON_ARR); $i++) {
            print encode('Shift_JIS', $JSON_ARR[$i]), "\n";
            # if ($JSON_ARR[$i] =~ /^(\d+_\S+)+_(\S+)/) {
            #     my $RESULT = encode('Shift_JIS', $2);
            #     print "$RESULT\n";
            # }
            push(@OUT_ARRAY, encode('Shift_JIS', $JSON_ARR[$i]));
        }

        # テキストファイルに出力
        my $OUT_FNAME = $F_PATH;
        $OUT_FNAME =~ s/json$/dat/g;
        print "OUT\t$OUT_FNAME\n";
        &output_result($OUT_FNAME, \@OUT_ARRAY);
        # print "\n";
        # last if ($F_PATH =~ /PDMonster000005/);
    }
}
# MAIN関数実行
&main($ROOTDIR);