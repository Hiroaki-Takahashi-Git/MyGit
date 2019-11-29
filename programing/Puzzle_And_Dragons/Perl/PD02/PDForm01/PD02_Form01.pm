use utf8;
use strict;
use warnings;
use Tk;
use Encode qw(decode encode);

require '.\PDDefine\PD02_Define.pm';
require '.\PDForm02\PD02_Form02.pm';
require '.\PDForm03\PD02_Form03.pm';
require '.\PDForm05\PD02_Form05.pm';

sub Form01_Func01_Main {

    &Init_Form;

    my $Form01 = MainWindow->new();
    $Form01->optionAdd('*font' => ['', 14]);
    $Form01->title('JSONデータ取得初期画面');
    my $Form01_TITLE = $Form01->Label(-text => 'JSONデータ')->pack();
    my $FRM01_F0 = $Form01->Frame();
    my $LBL01 = $FRM01_F0->Label(-text => '番号を入力して下さい。',)->pack(-fill => 'x', -padx => 10, -pady => 10);
    my $TBX01 = $FRM01_F0->Entry(-text => '', -width => 30, )->pack(-padx => 10, -pady => 10);
    my $LBL02 = $FRM01_F0->Label(-text => '名前を入力して下さい。',)->pack(-fill => 'x', -padx => 10, -pady => 10);
    my $TBX02 = $FRM01_F0->Entry(-text => '', -width => 30, )->pack(-padx => 10, -pady => 10);
    my $FRM01_F1 = $Form01->Frame();
    my $BTN01 = $FRM01_F1->Button(-text => '検索', -command => [\&Form01_Func02_CheckInput, $Form01, $TBX01, $TBX02],)->pack(-side => 'left', -padx => 10, -pady => 10);
    my $BTN02 = $FRM01_F1->Button(-text => '更新', -command => [\&Form05_Func01_Main])->pack(-side => 'left', -padx => 10, -pady => 10);
    my $BTN99 = $FRM01_F1->Button(-text => '終了', -command => \&exit,)->pack(-side => 'left', -padx => 10, -pady => 10);
    $FRM01_F0->pack();
    $FRM01_F1->pack();

    &Add_Form($Form01);

    MainLoop();
}

sub Form01_Func02_CheckInput {
    my ($WIDGET, $TBX1, $TBX2) = @_;

    my $tbx1_val = $TBX1->get;
    my $tbx2_val = $TBX2->get;

    my $msg = "エラーメッセージ";

    # 先に開いているフレームを消す
    if (Exists($WIDGET)) {
        $WIDGET->withdraw;
    }

    if ($tbx1_val eq '' && $tbx2_val eq '') {
        $msg = "数字か検索ワードを入力して下さい。";
        print encode('Shift_JIS', $msg), "\n";
        &Form01_Func01_Main();
    } elsif ($tbx1_val eq '' && $tbx2_val ne '') {
        # 検索ワードを含むモンスター名を検索
        &Form03_Func01_Main($tbx2_val);
    } else {
        if ($tbx1_val =~ /^\d+$/) {
            &Form02_Func01_Main($tbx1_val);
        } else {
            $msg = "全部数字で入力して下さい。";
            print encode('Shift_JIS', $msg), "\n";
            &Form01_Func01_Main();
        }
    }
}
1;