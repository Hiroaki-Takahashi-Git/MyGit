use utf8;
use strict;
use warnings;
use Tk;
use Encode qw(decode encode);

require '.\PDDefine\PD02_Define.pm';
require '.\PDForm02\PD02_Form02.pm';
require '.\PDForm03\PD02_Form03.pm';
require '.\PDForm05\PD02_Form05.pm';
require '.\PDForm06\PD02_Form06.pm';

sub Form01_Func01_Main {

    &Init_Form;

    my $Form01 = MainWindow->new();
    $Form01->optionAdd('*font' => ['', 14]);
    $Form01->title('初期画面');
    my $Form01_TITLE = $Form01->Label(-text => '操作を選んでください。')->pack();
    my $FRM01_F0 = $Form01->Frame();
    my $FRM01_F1 = $Form01->Frame();
    my $BTN01 = $FRM01_F0->Button(-text => '表示', -command => \&Form01_Func02_Display)->grid(-row => 0, -column => 0, -padx => 10, -pady => 10);
    my $BTN02 = $FRM01_F0->Button(-text => '検索', -command => \&Form01_Func03_Search) ->grid(-row => 0, -column => 1, -padx => 10, -pady => 10);
    my $BTN03 = $FRM01_F0->Button(-text => '集計', -command => \&Form04_Func01_Main)->grid(-row => 0, -column => 2, -padx => 10, -pady => 10);
    my $BTN04 = $FRM01_F0->Button(-text => '更新', -command => \&Form05_Func01_Main)->grid(-row => 1, -column => 0, -padx => 10, -pady => 10);
    my $BTN05 = $FRM01_F0->Button(-text => '最適化', -command => \&Form06_Func01_Main)->grid(-row => 1, -column => 1, -padx => 10, -pady => 10);
    my $BTN06 = $FRM01_F0->Button(-text => '全CSV出力', -command => \&Form01_Func04_OutputToCSV, )->grid(-row => 1, -column => 2, -padx => 10, -pady => 10);
    my $BTN99 = $FRM01_F1->Button(-text => '終了', -command => \&exit,)->pack();
    $FRM01_F0->pack(-padx => 10, -pady => 10);
    $FRM01_F1->pack(-padx => 10, -pady => 10);

    &Add_Form($Form01);

    MainLoop();
}

sub Form01_Func02_Display {

    &Init_Form;

    my $Form01_02 = MainWindow->new();
    $Form01_02->optionAdd('*font' => ['', 14]);
    $Form01_02->title('JSONデータ表示');

    my $FRM01_02_F1 = $Form01_02->Frame()->pack(-padx => 10, -pady => 10);
    my $FRM01_02_F2 = $Form01_02->Frame()->pack(-padx => 10, -pady => 10);

    $FRM01_02_F1->Label(-text => '番号を入力して下さい。')->pack(-fill => 'x', -padx => 10, -pady => 10);
    my $TBX01 = $FRM01_02_F1->Entry(-text => '', -width => 30,)->pack(-padx => 10, -pady => 10);

    my $BTN01 = $FRM01_02_F2->Button(-text => '開始', -command => [\&Form01_Func05_CheckInput, $TBX01])->grid(-row => 0, -column => 0, -padx => 10, -pady => 10);
    my $BTN02 = $FRM01_02_F2->Button(-text => '戻る', -command => \&Form01_Func01_Main)->grid(-row => 0, -column => 1, -padx => 10, -pady => 10);
    my $BTN99 = $FRM01_02_F2->Button(-text => '終了', -command => \&exit, )->grid(-row => 0, -column => 2, -padx => 10, -pady => 10);

    &Add_Form($Form01_02);

    MainLoop();
}

sub Form01_Func03_Search {

    &Init_Form;

    my $Form01_02 = MainWindow->new();
    $Form01_02->optionAdd('*font' => ['', 14]);
    $Form01_02->title('モンスター名検索');

    my $FRM01_02_F1 = $Form01_02->Frame()->pack(-padx => 10, -pady => 10);
    my $FRM01_02_F2 = $Form01_02->Frame()->pack(-padx => 10, -pady => 10);

    $FRM01_02_F1->Label(-text => 'キーワードを入力して下さい。')->pack(-fill => 'x', -padx => 10, -pady => 10);
    my $TBX01 = $FRM01_02_F1->Entry(-text => '', -width => 30,)->pack(-padx => 10, -pady => 10);

    my $BTN01 = $FRM01_02_F2->Button(-text => '開始', -command => [\&Form01_Func05_CheckInput, $TBX01])->grid(-row => 0, -column => 0, -padx => 10, -pady => 10);
    my $BTN02 = $FRM01_02_F2->Button(-text => '戻る', -command => \&Form01_Func01_Main)->grid(-row => 0, -column => 1, -padx => 10, -pady => 10);
    my $BTN99 = $FRM01_02_F2->Button(-text => '終了', -command => \&exit, )->grid(-row => 0, -column => 2, -padx => 10, -pady => 10);

    &Add_Form($Form01_02);

    MainLoop();
}

sub Form01_Func04_OutputToCSV {
    my $DATADIR = &Define_Item('PD_DATADIR');
    # print $DATADIR, "\n";
    opendir(DIR, "$DATADIR") or die "Error!!!";
    my @list = readdir(DIR);
    foreach my $sub_d (@list) {
        if ($sub_d =~ /PDMonster(\d+)/) {
            # printf("%s\\%s\n", $DATADIR, $sub_d);
            # printf("%6d\n", $1);
            &Form02_Func09_MakeCSVFile($1);
        }
    }
    closedir(DIR);
}

sub Form01_Func05_CheckInput {
    my ($TBX1) = @_;

    my $tbx1_val = $TBX1->get;

    my $msg = "エラーメッセージ";

    if ($tbx1_val eq '') {
        $msg = "数字か検索ワードを入力して下さい。";
        print encode('Shift_JIS', $msg), "\n";
        &Form01_Func01_Main();
    } elsif ($tbx1_val =~ /^\d{1,4}$/) {
        &Form02_Func01_Main($tbx1_val);
    } else {
        &Form03_Func01_Main($tbx1_val);
    }
}
1;