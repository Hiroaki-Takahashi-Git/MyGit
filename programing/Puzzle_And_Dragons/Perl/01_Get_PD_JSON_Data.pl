# UTF8->SJISに変換する
use strict;
use warnings;
use utf8;
use JSON;
use File::Slurp;
use Encode qw/encode decode/;
use Scalar::Util;

# my $JSON_FILE = $ARGV[0];
my $JSON_DIR = $ARGV[0];

# # my $JSON_DATA = &get_json_contents($JSON_FILE);

# # print encode('Shift_JIS', $JSON_DATA->{name});
# # print "\n";
# # print encode('Shift_JIS', $JSON_DATA->{parameters}->{HP}->{最大});

# # パスドラ連想配列1(モンスター属性)
# my %HASH01_PD_ATTR = (
#     "火"=>0,
#     "水"=>0,
#     "木"=>0,
#     "光"=>0,
#     "闇"=>0
# );
# # パスドラ連想配列2(モンスタータイプ)
# my %HASH02_PD_TYPE = (
#     "ドラゴンタイプ"=>0,
#     "バランスタイプ"=>0,
#     "回復タイプ"=>0,
#     "攻撃タイプ"=>0,
#     "体力タイプ"=>0,
#     "悪魔タイプ"=>0,
#     "神タイプ"=>0,
#     "マシンタイプ"=>0,
#     "強化合成用モンスター"=>0,
#     "進化用モンスター"=>0,
#     "覚醒用モンスター"=>0,
#     "売却用モンスター"=>0
# );
# # パズドラ連想配列3(リーダースキル)
# my %HASH03_PD_LSKILL = (
#         "7×6マス"=>0,
#         "HP倍率"=>0,
#         "HP制限"=>0,
#         "HP半減"=>0,
#         "L字消し"=>0,
#         "その他"=>0,
#         "コインUP"=>0,
#         "コンボ倍率"=>0,
#         "コンボ加算"=>0,
#         "サブ指定"=>0,
#         "スキル使用時"=>0,
#         "タイプ倍率"=>0,
#         "ダメージ軽減"=>0,
#         "マルチ倍率"=>0,
#         "全パラメータ 倍率"=>0,
#         "十字消し"=>0,
#         "反撃"=>0,
#         "回復倍率"=>0,
#         "回復制限"=>0,
#         "回復半減"=>0,
#         "固定ダメージ"=>0,
#         "多色倍率"=>0,
#         "属性倍率"=>0,
#         "強化ドロップ消し"=>0,
#         "指定数消し"=>0,
#         "操作時間固定"=>0,
#         "操作時間延長"=>0,
#         "操作時間短縮"=>0,
#         "攻撃倍率"=>0,
#         "根性"=>0,
#         "残りドロップ数"=>0,
#         "毒ダメージ無効"=>0,
#         "猛反撃"=>0,
#         "経験値UP"=>0,
#         "自動回復"=>0,
#         "落ちコンなし"=>0,
#         "覚醒無効回復"=>0,
#         "超反撃"=>0,
#         "追加攻撃"=>0,
#     );
# # パズドラ連想配列4(固有スキル)
# my %HASH04_PD_USKILL = (
#         "HP全回復"=>0,
#         "HP回復"=>0,
#         "L字ドロップ変換"=>0,
#         "その他"=>0,
#         "エンハンス"=>0,
#         "コンボ加算"=>0,
#         "ダブルドロップ変換"=>0,
#         "ダメージ無効化"=>0,
#         "ダメージ軽減"=>0,
#         "ドロップリフレッシュ"=>0,
#         "ドロップ変換"=>0,
#         "ドロップ強化"=>0,
#         "バインド全回復"=>0,
#         "バインド回復"=>0,
#         "ヘイスト"=>0,
#         "リーダーチェンジ"=>0,
#         "ルート表示"=>0,
#         "ロック"=>0,
#         "ロック解除"=>0,
#         "一定ダメージ"=>0,
#         "全ドロップ変換（陣）"=>0,
#         "全体ダメージ"=>0,
#         "全体攻撃化"=>0,
#         "割合ダメージ"=>0,
#         "十字ドロップ変換"=>0,
#         "単体ダメージ"=>0,
#         "反撃"=>0,
#         "回復力上昇"=>0,
#         "回復力減少"=>0,
#         "固定ダメージ"=>0,
#         "外周ドロップ変換"=>0,
#         "威嚇"=>0,
#         "属性ダメージ"=>0,
#         "属性吸収無効化"=>0,
#         "属性変化"=>0,
#         "恨み系ダメージ"=>0,
#         "操作時間延長"=>0,
#         "操作時間減少"=>0,
#         "攻撃吸収無効化"=>0,
#         "敵属性変化"=>0,
#         "時間停止"=>0,
#         "横列ドロップ変換"=>0,
#         "正方形ドロップ変換"=>0,
#         "毒"=>0,
#         "消せないドロップ状態回復"=>0,
#         "無効貫通"=>0,
#         "特定ドロップ目覚め"=>0,
#         "猛反撃"=>0,
#         "目覚め"=>0,
#         "継続回復"=>0,
#         "縦列ドロップ変換"=>0,
#         "自傷"=>0,
#         "花火"=>0,
#         "落ちコンなし"=>0,
#         "覚醒スキル全回復"=>0,
#         "覚醒スキル回復"=>0,
#         "超反撃"=>0,
#         "超絶反撃"=>0,
#         "防御力減少"=>0,
# );
# # パズドラ連想配列05(モンスターパラメータ)
# sub get_json_contents {
#     my ($fname) = @_;

#     # print "File : $fname\n";

#     my $json_data = File::Slurp::read_file($fname);
#     my $json = JSON::decode_json($json_data);

#     return ($json);
# }

# sub check_hash_element {
#     my ($json, $str, $hash) = @_;

#     my %out_hash;
#     foreach my $key (sort(keys(%{$hash}))) {
#         my $resp = $json->{$str}->{$key};
#         # print "resp\t", encode('Shift_JIS', $resp), "\n";
#         if ($resp == 1 || "$resp" eq "true" ) {
#             $out_hash{$key} = 1;
#         } else {
#             $out_hash{$key} = 0;
#         }
#     }

#     return(%out_hash);
# }

# sub check_hash_value {
#     my ($input) = @_;
#     while ((my ($key, $val) = each(%{$input})) != NULL ) {
#         my $key_shift = encode('Shift_JIS', $key);
#         my $val_shift = encode('Shift_JIS', $val);
#         print "$key_shift\t$val_shift\n";
#     }
# }

# sub extract_json_value {
#     my ($json, $str) = @_;
#     my $resp = $json->{$str};
#     # my $resp = encode('Shift_JIS', $json->{$str});
#     if (!$resp) {
#         $resp = 0;
#     }
#     return ($resp);
# }

# sub extract_json_data_all {
#     my ($json_data_org) = @_;

#     my  @output = ();

#     for my $var (sort(keys(%{$json_data_org}))) {
#         my $ref_type = ref($$json_data_org{$var});
#         if ("$ref_type" eq "HASH") {
#             my @output2 = &extract_json_data_all($$json_data_org{$var});
#             push(@output, @output2);
#         } else {
#             # print encode('Shift_JIS', $var), "\t";
#             # print encode('Shift_JIS', $$json_data_org{$var}), "\n";
#             next if ($var =~ /限界突破/ || $var =~ /プラス/);
#             if ($$json_data_org{$var} =~ /^\d+$/) {
#                 push(@output, sprintf("%06d", $$json_data_org{$var}));
#             } else {
#                 push(@output, $$json_data_org{$var});
#             }
#         }
#     }

#     # foreach my $elem (@output) {
#     #     print "$elem\n";
#     # }

#     return(@output);
# }

# sub hash_init {
#     foreach my $l_key (%HASH03_PD_LSKILL) {
#         $HASH03_PD_LSKILL{$l_key} = 0;
#     }
#     foreach my $u_key (%HASH04_PD_USKILL) {
#         $HASH04_PD_USKILL{$u_key} = 0;
#     }
# }

# sub make_output_tsv {
#     my ($in_arr) = @_;
#     my $arr_sz = scalar(@{$in_arr});
#     my $o_fname = sprintf("%s\\All\\PD_ALL_Data.tsv", $JSON_DIR);
#     open (TSV, "> $o_fname") or die "ERROR";
#     for (my $i = 0; $i < $arr_sz; $i++) {
#         print TSV $$in_arr[$i], "\n";
#     }
#     close(TSV);
# }

sub MAIN {
    my ($DIRPATH) = @_;

    my %LSKILL_HASH;
    my %USKILL_HASH;

    opendir(DIR, "$DIRPATH") or die "Error!!";
    my @dir_list = readdir(DIR);

    my @PD_ALL_ARRAY = ();

    foreach my $subd (@dir_list) {
        my @PD_UNIT_ARRAY = ();

        next if ($subd =~ /^\.+$/);
        next if ($subd !~ /PDMonster\d+/);
        print "$subd\n";

        # &hash_init;

        my $pd_json_utf8 = sprintf("%s\\%s\\%s.json", $DIRPATH, $subd, $subd);
        my $pd_json_sjis = sprintf("%s\\%s\\%s_sjis.json", $DIRPATH, $subd, $subd);
        next if ( ! -e "$pd_json_utf8");
        open("JSON_SJIS", "> $pd_json_sjis") or die "Error(Cannot open ${pd_json_sjis}!!)" ;
        open("JSON_UTF8", "< $pd_json_utf8") or die "Error(Cannot open ${pd_json_utf8}!!)";
        while (my $linedata1 = <JSON_UTF8>) {
            chomp($linedata1);
            my $linedata_utf8 = decode('utf8', $linedata1);
            my $linedata_sjis = encode('Shift_JIS', $linedata_utf8);
            print JSON_SJIS "$linedata_sjis", "\n";
        }
        close("JSON_UTF8");
        close("JSON_SJIS");
        # # print "$pd_json\n";
        # next if (! -f $pd_json);

        # my $JSON_D = &get_json_contents($pd_json);

        # my $PD_NUMBER = &extract_json_value($JSON_D, "number");
        # my $PD_NAME = &extract_json_value($JSON_D, "name");
        # my $PD_RARE = &extract_json_value($JSON_D, "rare");
        # my $PD_COST = &extract_json_value($JSON_D, "cost");
        # my $PD_ASSIST = &extract_json_value($JSON_D, "assistance");
        # push(@PD_UNIT_ARRAY,
        #         $PD_NUMBER,
        #         $PD_NAME,
        #         $PD_RARE,
        #         $PD_COST,
        #         $PD_ASSIST,
        #     );

        # my %PD_HASH_ATTR = &check_hash_element($JSON_D, 'attribute', \%HASH01_PD_ATTR);
        # # &check_hash_value(\%PD_HASH_ATTR);
        # my %PD_HASH_TYPE = &check_hash_element($JSON_D, 'type', \%HASH02_PD_TYPE);
        # # &check_hash_value(\%PD_HASH_TYPE);
        # push(@PD_UNIT_ARRAY,
        #         values(%PD_HASH_ATTR),
        #         values(%PD_HASH_TYPE),
        #     );

        # my @PD_ARRAY_PARAMETERS1 = &extract_json_data_all($JSON_D->{parameters}->{HP});
        # my @PD_ARRAY_PARAMETERS2 = &extract_json_data_all($JSON_D->{parameters}->{攻撃});
        # my @PD_ARRAY_PARAMETERS3 = &extract_json_data_all($JSON_D->{parameters}->{回復});
        # push(@PD_UNIT_ARRAY,
        #         sort(@PD_ARRAY_PARAMETERS1),
        #         sort(@PD_ARRAY_PARAMETERS2),
        #         sort(@PD_ARRAY_PARAMETERS3),
        #     );

        # my @PD_ARRAY_LSKILL = &extract_json_data_all($JSON_D->{skills}->{リーダースキル}->{タイプ});
        # my @PD_ARRAY_USKILL = &extract_json_data_all($JSON_D->{skills}->{スキル}->{タイプ});
        # foreach my $elem (@PD_ARRAY_LSKILL) {
        #     # print encode('Shift_JIS', $elem), "\n";
        #     $HASH03_PD_LSKILL{$elem}++;
        # }
        # foreach my $elem (@PD_ARRAY_USKILL) {
        #     $HASH04_PD_USKILL{$elem}++;
        # }
        # push(@PD_UNIT_ARRAY,
        #         values(%HASH03_PD_LSKILL),
        #         values(%HASH04_PD_USKILL),
        # );

        # my $LINEDATA = join("\t", @PD_UNIT_ARRAY);
        # $LINEDATA = encode('Shift_JIS', $LINEDATA);
        # # print encode('Shift_JIS', $LINEDATA), "\n";
        # # print "$LINEDATA\n";

        # if ("$subd" eq "PDMonster000001") {
        #     # exit(0);
        #     last;
        # }
        # push(@PD_ALL_ARRAY, $LINEDATA);
    }
    closedir(DIR);

    # &make_output_tsv(\@PD_ALL_ARRAY);
}

&MAIN($JSON_DIR);