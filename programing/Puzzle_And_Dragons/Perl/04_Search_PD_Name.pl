use utf8;
use strict;
use warnings;
use Encode 'decode';
use Encode 'encode';
use JSON;
use File::Slurp;

my $ROOTDIR = $ARGV[0];
my $KEYNAME = $ARGV[1];
my $OUTROOT = $ARGV[2];

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
# JSONデータを取得する(2)
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
# 検索結果をファイルに書き込み
sub write_number_name_list {
    my ($OUT_FNAME, $IN_ARR) = @_;
    my $arr_sz = scalar(@{$IN_ARR});

    open(OUT, "> $OUT_FNAME") or die "Error";
    if ($arr_sz == 0)
    {
        print OUT "000000", "\t", "NODATA", "\n";
    }
    else{
        for (my $i = 0; $i < $arr_sz; $i++)
        {
            print OUT "$$IN_ARR[$i]", "\n";
        }
    }
    close(OUT);
}
# MAIN関数
sub main {
    my ($ROOTDIR, $KEYSTRING, $OUT_ROOT) = @_;
    # print "ROOTDIR : $ROOTDIR\n";
    # print "$KEYSTRING\n";
    my $REF_NAME = '';
    my $REF_NUM = 9999;

    # リストを作成
    my @JSON_ARR = &make_json_list($ROOTDIR);
    # print scalar(@JSON_ARR);

    # JSONデータを取得
    my @list = ();
    foreach my $F_PATH (@JSON_ARR) {
        # next if ($F_PATH !~ /PDMonster003386/);
        print "$F_PATH\n";
        
        # JSON形式からハッシュ形式に変換
        my $JSON_DATA = &get_json_contents($F_PATH);
        # print "$JSON_DATA", "\n";

        # # ハッシュ形式から配列形式に変換
        # my @JSON_ARR = &get_json_parts($JSON_DATA);
        # for (my $i = 0; $i < scalar(@JSON_ARR); $i++) {
        #     print encode('Shift_JIS', $JSON_ARR[$i]), "\n";
        #     # if ($JSON_ARR[$i] =~ /^(\d+_\S+)+_(\S+)/) {
        #     #     my $RESULT = encode('Shift_JIS', $2);
        #     #     print "$RESULT\n";
        #     # }
        # }
        my @KEY_ARR = keys(%{$JSON_DATA});
        next if (! grep {$_ eq 'name'} @KEY_ARR);
        $REF_NUM = $JSON_DATA->{number};
        $REF_NAME = $JSON_DATA->{name};
        next if ($REF_NAME =~ /^$/);
        $REF_NAME = encode('Shift_JIS', $REF_NAME);
        # print "NAME : $REF_NAME\n";
        if ($REF_NAME =~ /$KEYSTRING/)
        {
            my $linedata = sprintf("%06d\t%s", $REF_NUM, $REF_NAME);
            push(@list, $linedata);
            # printf("%06d\t", $REF_NUM);
            # printf("%s\n", $REF_NAME);
            # print "$linedata\n";
        }
        # printf("%06d\t", $REF_NUM);
        # print encode('Shift_JIS', $REF_NAME), "\n";

        # print "\n";
        # last if ($F_PATH =~ /PDMonster000005/);
    }

    # ファイルへの書き込み
    my $OUT_FNAME = sprintf("%s\\name_list.txt", $OUT_ROOT);
    &write_number_name_list($OUT_FNAME, \@list);
}
# MAIN関数実行
&main($ROOTDIR, $KEYNAME, $OUTROOT);