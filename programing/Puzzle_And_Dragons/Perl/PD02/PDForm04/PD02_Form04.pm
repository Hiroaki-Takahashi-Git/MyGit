use utf8;
use strict;
use warnings;
use Tk;
use Class::Struct;

require '.\PDDefine\PD02_Define.pm';
require '.\PDForm01\PD02_Form01.pm';
require '.\PDForm02\PD02_Form02.pm';

struct PD_Data => {
    number  =>  '$',
    name    =>  '$',
};

my @PD_MEMBER = ();

sub Form04_Func01_Main {
    my ($IN_NUM, $IN_NAME) = @_;

    &Init_Form;
    # 入力用画面の生成
    my $FRM04 = MainWindow->new();
    $FRM04->optionAdd('*font' => ['', 14],);
    $FRM04->title('パーティーメンバー入力画面');
    my $FRM04_TITLE = $FRM04->Label(-text => 'パーティーメンバー入力')->pack();

    # リーダー部分
    my $FRM04_LF01 = $FRM04->Labelframe(-text => 'リーダー')->pack(-fill => 'x', -padx => 10, -pady => 10);
    $FRM04_LF01->configure(-labelanchor => 'nw');
    my $PD_LEAD_NUM = $FRM04_LF01->Entry(-text => "$IN_NUM", -width => 20)->grid(-row => 0, -column => 0, -padx => 10, -pady => 10);
    my $PD_LEAD_NAME = $FRM04_LF01->Entry(-text => "$IN_NAME", -width => 50)->grid(-row => 0, -column => 1, -padx => 10, -pady => 10);
    my $PD_Struct = PD_Data->new();
    $PD_Struct->number($PD_LEAD_NUM);
    $PD_Struct->name($PD_LEAD_NAME);
    push(@PD_MEMBER, $PD_LEAD_NUM);

    # サブメンバー部分
    my $FRM04_LF02 = $FRM04->Labelframe(-text => 'サブメンバー')->pack(-fill => 'x', -padx => 10, -pady => 10);
    $FRM04_LF02->Label(-text => "番号")->grid(-row => 0, -column => 0, -ipadx => 5, -ipady => 5);
    $FRM04_LF02->Label(-text => "名前")->grid(-row => 0, -column => 1, -ipadx => 5, -ipady => 5);
    $FRM04_LF02->configure(-labelanchor => 'nw');
    for (my $i = 0; $i < 4; $i++) {
        my $PD_SUB_NUM = $FRM04_LF02->Entry(-text => "", -width => 20)->grid(-row => $i+1, -column => 0, -padx => 10, -pady => 10);
        my $PD_SUB_NAME = $FRM04_LF02->Entry(-text => "", -width => 50)->grid(-row => $i+1, -column => 1, -padx => 10, -pady => 10);
        push(@PD_MEMBER, $PD_SUB_NUM);
    }

    # アシスタント部分
    my $FRM04_LF03 = $FRM04->Labelframe(-text => 'アシスタント')->pack(-fill => 'x', -padx => 10, -pady => 10);
    $FRM04_LF03->configure(-labelanchor => 'nw');
    my $PD_ASSIST_NUM = $FRM04_LF03->Entry(-text => '', -width => 20)->grid(-row => 0, -column => 0, -padx => 10, -pady => 10);
    my $PD_ASSIST_NAME = $FRM04_LF03->Entry(-text => '', -width => 50)->grid(-row => 0, -column => 1, -padx => 10, -pady => 10);
    push(@PD_MEMBER, $PD_ASSIST_NUM);

    # ボタン部分
    my $FRM04_FR01 = $FRM04->Frame()->pack(-fill => 'x', -padx => 10, -pady => 10);
    $FRM04_FR01->Button(-text => '戻る', -command => \&Form01_Func01_Main)->grid(-row => 0, -column => 0, -padx => 10, -pady => 10);
    $FRM04_FR01->Button(-text => '集計', -command => [\&Form04_Func02_Collect, \@PD_MEMBER],)->grid(-row => 0, -column => 1, -padx => 10, -pady => 10);
    $FRM04_FR01->Button(-text => '終了', -command => \&exit)->grid(-row => 0, -column => 2, -padx => 10, -pady => 10);

    MainLoop();

    &Add_Form($FRM04);
}

sub Form04_Func02_Collect {
    my ($IN_ARR) = @_;
    my %JSON_HASH2;
    my $IN_STR;
    my $PD_ROOTDIR = &Define_Item('PD_DATADIR');
    print "ROOTDIR : $PD_ROOTDIR\n";
    my @para_content_list = ('HP', '攻撃', '回復');
    my @para_item_list = ('最大', 'プラス', '限界突破', '限界突破プラス');

    my $ARR_SZ = scalar(@{$IN_ARR});
    print "Array Size : $ARR_SZ\n";
    for (my $i = 0; $i < $ARR_SZ; $i++) {
    #     print "i = $$IN_ARR[$i]\n";
        my $NUM_WI = $$IN_ARR[$i];
        # print "$NUM_WI\n";
        my $number = $NUM_WI->get();
        next if ($number =~ /^$/);
        print "Number : ", encode('Shift_JIS', $number), "\n";

        # JSONファイルの設定
        my $PD_MONSTER_STR = sprintf("PDMonster%06d", $number);
        my $PD_MONSTER_JSON = sprintf("%s\\%s\\%s.json", $PD_ROOTDIR, $PD_MONSTER_STR, $PD_MONSTER_STR);
        print "JSON:$PD_MONSTER_JSON\n";

        # JSONデータの取得
        my $JSON_DATA = &Form02_Func03_ReadJSONFile($PD_MONSTER_JSON);
        my %JSON_HASH1 = &Form02_Func04_GetJSONData($JSON_DATA, 'PD');
        my @JSON_KEY_ARR1 = keys(%JSON_HASH1);
        foreach my $KEY (@JSON_KEY_ARR1) {
            my $VAL = $JSON_HASH1{$KEY};
            if ($VAL =~ /^\d+$/) {
                $JSON_HASH2{$KEY} += $VAL;
            }
        }
    }

    # 結果を出力
    # パラメータ
    my @para_content_list2 = ('HP', '攻撃', '回復');
    my @para_item_list2 = ('最大', 'プラス', '限界突破', '限界突破プラス');
    print encode('Shift_JIS', "パラメータ"), "\n";
    while (my ($key, $val) = each(%JSON_HASH2)) {
        if ($key =~ /parameters/) {
            print encode('Shift_JIS', $key), "\t", encode('Shift_JIS', $val), "\n";
        }
    }

    # 覚醒
    print encode('Shift_JIS', "覚醒"), "\n";
    while (my ($key, $val) = each(%JSON_HASH2)) {
        if ($key =~ /awake[12]/) {
            print encode('Shift_JIS', $key), "\t", encode('Shift_JIS', $val), "\n";
        }
    }

    # キラー
    print encode('Shift_JIS', "キラー"), "\n";
    while (my ($key, $val) = each(%JSON_HASH2)) {
        if ($key =~ /killer/) {
            print encode('Shift_JIS', $key), "\t", encode('Shift_JIS', $val), "\n";
        }
    }

}

1;
