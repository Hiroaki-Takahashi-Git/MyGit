use utf8;
use strict;
use warnings;
use Tk;

require '.\PDDefine\PD02_Define.pm';
require '.\PDForm01\PD02_Form01.pm';
# require '.\PDForm02\PD02_Form05.pm';

sub Form05_Func01_Main {

    &Init_Form;

    my $FRM05 = MainWindow->new();
    $FRM05->optionAdd('*font' => ['', 14],);
    $FRM05->title('新規JSONデータ取得');
    my $FRM05_TITLE = $FRM05->Label(-text => '新規JSONデータ')->pack();

    my $FRM05_F0 = $FRM05->Frame();
    my $FRM05_F1 = $FRM05->Frame();
    
    my $LBL_LABEL_START = $FRM05_F0->Label(-text => "開始", -anchor => 'w')->grid(-row => 0, -column => 0, -ipadx => 10, -ipady => 10);
    my $LBL_INPUT_START = $FRM05_F0->Entry(-text => "",)->grid(-row => 0, -column => 1, -ipadx => 10, -ipady => 10);
    my $LBL_LABEL_STOP  = $FRM05_F0->Label(-text => "終了", -anchor => 'w')->grid(-row => 1, -column => 0, -ipadx => 10, -ipady => 10);
    my $LBL_INPUT_STOP  = $FRM05_F0->Entry(-text => "",)->grid(-row => 1, -column => 1, -ipadx => 10, -ipady => 10);

    my $BTN_GETJSONDATA = $FRM05_F1->Button(-text => "取得", -command => [\&Form05_Func02_GetJSONData, $LBL_INPUT_START, $LBL_INPUT_STOP])->pack(-side => 'left', -padx => 10, -pady => 10);
    my $BTN_BACKTOPFORM = $FRM05_F1->Button(-text => "戻る", -command => [\&Form01_Func01_Main])->pack(-side => 'left', -padx => 10, -pady => 10);

    $FRM05_F0->pack();
    $FRM05_F1->pack(-padx => 10, -pady => 10);

    &Add_Form($FRM05);

    MainLoop();
}

sub Form05_Func02_GetJSONData {
    my ($INPUT1, $INPUT2) = @_;

    my $pd_datadir  = &Define_Item('PD_DATADIR');
    my $pd_python   = sprintf("%s\\Extract_PD_Data_All.py", &Define_Item('TOOL_PYTHON'));
    my $pd_s_num    = $INPUT1->get;
    my $pd_e_num    = $INPUT2->get;

    print "$pd_python\n";
    print "$pd_s_num\t$pd_e_num\n";

    # JSONデータの取得
    print encode('Shift_JIS', "取得開始"), "\t", sprintf("%04d", $pd_s_num), "\n";
    open(COM, "|python $pd_python $pd_datadir $pd_s_num $pd_e_num") or die "Error!!";
    close(COM);
    print encode('Shift_JIS', "取得終了"), "\t", sprintf("%04d", $pd_e_num), "\n";

    &Form01_Func01_Main();
}
1;
