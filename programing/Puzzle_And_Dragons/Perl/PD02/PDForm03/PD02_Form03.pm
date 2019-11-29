use utf8;
use strict;
use warnings;
use JSON;
use Tk;
use Tk::Table;

require '.\PDDefine\PD02_Define.pm';
require '.\PDForm01\PD02_Form01.pm';

sub Form03_Func01_Main {
    my ($IN_KEYSTR) = @_;

    # print encode('Shift_JIS', $IN_KEYSTR), "\n";
    my %FRM03_LIST = &Form03_Func02_SearchJSONName($IN_KEYSTR);

    # 検索結果を表示する
    &Form03_Func03_DisplaySearchResult(\%FRM03_LIST);
}

sub Form03_Func02_SearchJSONName {
    my ($IN_STR) = @_;

    my $msg = "メッセージ用";
    my %OUTPUT;

    $msg = "検索開始";
    print encode('Shift_JIS', $msg), "\n";
    opendir(DIR,  &Define_Item('PD_DATADIR')) or die "Error!!";
    my @LIST = readdir(DIR);
    foreach my $sub (@LIST) {
        next if ($sub =~ /^\.+$/);
        if ($sub =~ /^PDMonster\d+$/) {
            my $JSON_F = sprintf("%s\\%s\\%s.json", &Define_Item('PD_DATADIR'), $sub, $sub);
            next if (! -f $JSON_F);
            my $JSON_HASH1 = &Form02_Func03_ReadJSONFile($JSON_F);

            my @KEY_LIST = keys(%{$JSON_HASH1});
            next if (! grep {$_ eq 'name'} @KEY_LIST);
            
            # my $PD_NUM = &Form02_Func03_GetJSONData($JSON_HASH, 'number');
            # my $PD_NAME = &Form02_Func03_GetJSONData($JSON_HASH, 'name');
            my $PD_NUM = $JSON_HASH1->{number};
            my $PD_NAME = $JSON_HASH1->{name};

            if ($PD_NAME =~ /$IN_STR/) {
                $PD_NUM = sprintf("%06d", $PD_NUM);
                # $PD_NAME = encode('Shift_JIS', $PD_NAME);
                print "$PD_NUM\t";
                print encode('Shift_JIS', $PD_NAME), "\n";
                $OUTPUT{$PD_NUM} = $PD_NAME;
            }
        }
    }
    closedir(DIR);
    
    $msg = "検索終了";
    print encode('Shift_JIS', $msg), "\n";

    return (%OUTPUT);
}

sub Form03_Func03_DisplaySearchResult {
    my ($IN_HASH) = @_;

    # 検索結果の件数を取得
    my $ITEM_CNT = scalar(keys(%{$IN_HASH}));

    # 検索結果画面の生成
    &Init_Form;
    my $FRM03  = MainWindow->new();
    $FRM03->optionAdd('*font' => ['', 14]);
    $FRM03->title('キーワード検索結果');
    my $title_str = sprintf("キーワード検索結果(%d件)", $ITEM_CNT);
    my $FRM03_TITLE = $FRM03->Label(-text => "$title_str")->pack(-fill => 'both');

    # リストボックスの生成
    my @KEY_LIST = sort(keys(%{$IN_HASH}));
    my $LIST_SZ = scalar(@KEY_LIST);
    my $FRM03_TBL01 = $FRM03->Table(-rows => 10, -columns => 3, -scrollbars => 'e',)->pack(-fill => 'x');
    my $rad_state = 'normal';
    for (my $i = 0; $i < $LIST_SZ; $i++) {
        my $PD_NUMBER  = $KEY_LIST[$i];
        my $PD_NAME = $$IN_HASH{$PD_NUMBER};
        my $FRM03_RAD01 = $FRM03_TBL01->Radiobutton(-variable => \$rad_state, -value => "$PD_NUMBER", -command => [\&Form03_Func03_ResearchJSONFile, $PD_NUMBER]);
        my $FRM03_LBL01 = $FRM03_TBL01->Label(-text => "$PD_NUMBER", -anchor => 'w')->pack();
        my $FRM03_LBL02 = $FRM03_TBL01->Label(-text => "$PD_NAME", -anchor => 'w')->pack();
        $FRM03_TBL01->put($i, 0, $FRM03_RAD01);
        $FRM03_TBL01->put($i, 1, $FRM03_LBL01);
        $FRM03_TBL01->put($i, 2, $FRM03_LBL02);
    }
    # &Add_Form($FRM03);

    # ボタンの設定
    my $FRM03_SUB99 = $FRM03->Frame()->pack(-padx => 10, -pady => 10);
    # my $BTN01 = $FRM03_SUB99->Button(-text => '検索', -command => [\&Form03_Func03_ReSearchJSONFile, $FRM03_TBL01])->pack(-side => 'left');
    my $BTN02 = $FRM03_SUB99->Button(-text => '戻る', -command => [\&Form03_Func04_Redisplay, $FRM03],)->pack(-side => 'left');
    MainLoop();
}

sub Form03_Func03_ResearchJSONFile {
    my ($IN_NUMBER) = @_;

    $IN_NUMBER = sprintf("%d", $IN_NUMBER);

    # foreach my $frm (@Frm03_Arr) {
    #     $frm->withdraw;
    # }

    # JSONファイル検索処理を実行
    &Form02_Func01_Main($IN_NUMBER);
}

sub Form03_Func04_Redisplay {
    my ($IN_FORM) = @_;

    $IN_FORM->withdraw;

    &Form02_Func06_ReDisplay;
}

1;    