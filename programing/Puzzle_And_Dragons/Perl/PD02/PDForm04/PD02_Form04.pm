use utf8;
use strict;
use warnings;
use Tk;

require '.\PDDefine\PD02_Define.pm';
require '.\PDForm01\PD02_Form01.pm';
require '.\PDForm02\PD02_Form02.pm';

sub Form04_Func01_Main {
    my ($IN_NUM, $IN_NAME) = @_;

    # 入力用画面の生成
    my $FRM04 = MainWindow->new();
    $FRM04->optionAdd('*font' => ['', 14],);
    $FRM04->title('パーティーメンバー入力画面');
    my $FRM04_TITLE = $FRM04->Label(-text => 'パーティーメンバー入力')->pack();

    # リーダー部分
    my $FRM04_LF01 = $FRM04->Labelframe(-text => 'リーダー')->pack(-fill => 'x', -padx => 10, -pady => 10);
    $FRM04_LF01->configure(-labelanchor => 'nw');
    $FRM04_LF01->Label(-text => "$IN_NUM", -anchor => 'w')->grid(-row => 0, -column => 0, -ipadx => 5, -ipady => 5);
    $FRM04_LF01->Label(-text => "$IN_NAME", -anchor => 'w')->grid(-row => 0, -column => 1, -ipadx => 5, -ipady => 5);

    # サブメンバー部分
    my $FRM04_LF02 = $FRM04->Labelframe(-text => 'サブメンバー')->pack(-fill => 'x', -padx => 10, -pady => 10);
    $FRM04_LF02->configure(-labelanchor => 'nw');
    for (my $i = 0; $i < 5; $i++) {
        $FRM04_LF02->Entry(-text => '', -width => 30)->grid(-row => $i, -column => 0, -ipadx => 5, -ipady => 5);
        $FRM04_LF02->Entry(-text => '', -width => 30)->grid(-row => $i, -column => 1, -ipadx => 5, -ipady => 5);
    }

    # アシスタント部分
    my $FRM04_LF03 = $FRM04->Labelframe(-text => 'アシスタント')->pack(-fill => 'x', -padx => 10, -pady => 10);
    $FRM04_LF03->configure(-labelanchor => 'nw');
    $FRM04_LF03->Entry(-text => '', -width => 30)->grid(-row => 0, -column => 0, -ipadx => 5, -ipady => 5);
    $FRM04_LF03->Entry(-text => '', -width => 30)->grid(-row => 0, -column => 1, -ipadx => 5, -ipady => 5);

    # ボタン部分
    my $FRM04_FR01 = $FRM04->Frame()->pack(-fill => 'x', -padx => 10, -pady => 10);
    $FRM04_FR01->Button(-text => '戻る', -command => \&Form01_Func01_Main)->grid(-row => 0, -column => 0);
    $FRM04_FR01->Button(-text => '終了', -command => \&exit)->grid(-row => 0, -column => 1);

    MainLoop();

    &Add_Form($FRM04);
}
1;
