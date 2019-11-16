# 最初に表示する画面
use utf8;
use warnings;
use strict;
use Tk;
use Tk::Table;
use Encode 'decode';
use Encode 'encode';
use JSON;
use File::Slurp;
use File::Path 'mkpath';

my $PD_ROOTDIR  = "F:\\Puzzle_and_Dragons";
my $PD_DATADIR  = sprintf("%s\\PD_Data", $PD_ROOTDIR);
my $PD_TOOLDIR  = "F:\\MyGit\\programing\\Puzzle_And_Dragons";
my $TOOL_PERL   = sprintf("%s\\Perl", $PD_TOOLDIR);
my $TOOL_PYTHON = sprintf("%s\\Python", $PD_TOOLDIR);

my $INPUT_NUM = "";

sub Form01_CheckInput {
    my ($tbx1, $tbx2) = @_;
    my $tbx_01 = $tbx1->get;
    my $tbx_02 = $tbx2->get;

    if ($tbx_01 eq '' && $tbx_02 eq '') {
        my $msg = "番号か検索用キーワードを入力して下さい。";
        print "Error!!!\n";
        print encode('Shift_JIS', $msg), "\n";
    }
    elsif (($tbx_01 ne '' && $tbx_02 eq '') ||
           ($tbx_01 ne '' && $tbx_02 ne '')) {
        if ($tbx_01 =~ /^\d+$/) {
            &Class01_GetJSONData($tbx_01);
        }
        else {
            my $msg = "数字を入力して下さい。";
            print "Error!!!\n";
            print encode('Shift_JIS', $msg), "\n";
        }
    }
    else {
        # モンスター名を探索
        &Class02_SearchPDMonsterName($tbx_02);
    }
}
sub Form02_DisplayGetItem {
    my ($in_pd_hash) = @_;

    # 画面の下地の作成
    my $FRM02 = MainWindow->new();
    my $FRM02_TITLE = $FRM02->Label(-text => 'JSONファイル取得結果')->pack();

    # 表示項目の設定
    # 番号、名前、レア、コスト
    my @disparr1 = ();
    my @disparr2 = ();
    my $PD_Number = sprintf("番号：%d\t", $in_pd_hash->{number});
    my $PD_Name = sprintf("名前：%s\t", $in_pd_hash->{name});
    push(@disparr1, $PD_Number, $PD_Name);
     my $PD_Rare = sprintf("レア度：%s\t", $in_pd_hash->{rare});
    my $PD_Cost = sprintf("コスト：%d", $in_pd_hash->{cost});
    # アシスト
    my $PD_Assist = $in_pd_hash->{assistance};
    # print "Assist\t$PD_Assist\n";
    if ($PD_Assist =~ /^0+$/) {
        $PD_Assist = sprintf("アシスト：×");
    } else {
        $PD_Assist = sprintf("アシスト：○");
    }
    push(@disparr2, $PD_Rare, $PD_Cost, $PD_Assist);
    my $FRM02_F0 = $FRM02->Frame();
    my $FRM02_F1 = $FRM02->Frame();
    foreach my $displbl1 (@disparr1) {
        $FRM02_F0->Label(-text => "$displbl1")->pack(-side => 'left');
    }
    foreach my $displbl2 (@disparr2) {
        $FRM02_F1->Label(-text => "$displbl2")->pack(-side => 'left');
    }


    # exit;
    # 終了ボタン
    my $FRM02_FEXIT = $FRM02->Frame();
    my $FRM02_BTN01 = $FRM02_FEXIT->Button(-text => '終了', -command => \&exit)->pack();
    $FRM02_F0->pack();
    $FRM02_F1->pack();
    $FRM02_FEXIT->pack();
}
sub Class01_GetJSONData {
    my ($in_number) = @_;

    # my $in_number = $tbx->get;
    my $PD_DIR = sprintf("%s\\PDMonster%06d", $PD_DATADIR, $in_number);
    my $PD_FIL = sprintf("%s\\PDMonster%06d.json", $PD_DIR, $in_number);

    # JSONファイルが存在してるか、確認
    my $RET = &Class01_CheckFileExist($PD_FIL);
    if ($RET != 0) {
        # JSONファイル格納ディレクトリを作成
        mkpath($PD_DIR);
        # JSONファイルの作成
        my $pd_py_module = sprintf("%s\\Extract_PD_Data.py", $TOOL_PYTHON);
        open(COM, "|python $pd_py_module $in_number $PD_FIL");
        close(COM);
        print "JSON File has been created!!\n";
    }

    # JSONファイルの読み込み
    my $JSON_SRC = &Class01_GetData($PD_FIL);

    # 取得結果表示用の画面生成処理に移行
    &Form02_DisplayGetItem($JSON_SRC);
}
sub Class01_CheckFileExist {
    my ($fname) = @_;
    my $ret = 0;
    if (! -f $fname)
    {
        $ret = 1;
    }
    return $ret;
}
# JSONファイルからデータを取得する
sub Class01_GetData {
    my ($fname) = @_;

    my $json_data = File::Slurp::read_file($fname);
    my $json = JSON::decode_json($json_data);

    return ($json);
}
# JSONデータの中身を取得する
sub Class01_GetJSONContents {
    my ($json_parent) = @_;
    my @output = ();

    my $index = 1;
    foreach my $pd_var (sort(keys(%{$json_parent}))) {
        my $pd_value = $$json_parent{$pd_var};
        my $val_ref = ref($pd_value);
        # 入れ子になっている場合は再帰的に出力する
        if ("$val_ref" eq "HASH") {
            # print "var : ", encode('Shift_JIS', "$var"), "\n";
            # $index++;
            my @output2 = &Class01_GetJSONContents($pd_value);
            for (my $i = 0; $i < scalar(@output2); $i++) {
                $output2[$i] = sprintf("%02d，%s，%s", $index, $pd_var, $output2[$i]);
            }
            push(@output, @output2);
        } else {
           if ($pd_value =~ /^\d+$/) {
                $pd_value = sprintf("%06d", $pd_value);
            }
            my $result = sprintf("%02d，%s，%s", $index, $pd_var, $pd_value);
            push(@output, $result);
        }
        $index++;
    }
    return(@output);
}
sub Class02_SearchPDMonsterName {
    my ($tbx) = @_;
    
    my $ref_string = $tbx;
    
    my %pd_map_num_name;

    opendir(DIR, "$PD_DATADIR") or die "ERROR!!!";
    my @dirlist = readdir(DIR);
    foreach my $subdir (@dirlist) {
        next if ($subdir =~ /^\.+$/);
        if ($subdir =~ /^PDMonster\d+$/) {
            # print "$subdir\n";
            my $JSON_FNAME = sprintf("%s\\%s\\%s.json", $PD_DATADIR, $subdir, $subdir);
            my $ret = &Class01_CheckFileExist($JSON_FNAME);
            if ($ret == 0) {
                # print "$JSON_FNAME\n";
                my $JSON_DATA = &Class01_GetData($JSON_FNAME);
                my @KEY_ARR = keys(%{$JSON_DATA});
                next if (! grep {$_ eq 'name'} @KEY_ARR);
                my $REF_NUM = $JSON_DATA->{number};
                my $REF_NAME = $JSON_DATA->{name};
                next if ($REF_NAME =~ /^$/);
                # $REF_NAME = encode('Shift_JIS', $REF_NAME);
                # print "NAME : $REF_NAME\n";
                if ($REF_NAME =~ /$ref_string/)
                {
                    # my $linedata = sprintf("%06d\t%s", $REF_NUM, $REF_NAME);
                    # push(@list, $linedata);
                    printf("%06d\t", $REF_NUM);
                    printf("%s\n", encode('Shift_JIS', $REF_NAME));
                    # print "$linedata\n";
                    $REF_NUM = sprintf("%06d", $REF_NUM);
                    $pd_map_num_name{$REF_NUM} = $REF_NAME;
                }
            }
        }
    }
    closedir(DIR);

    # 検索結果画面を表示
    &Form03_DisplaySearchItem(\%pd_map_num_name);
}
sub Form03_DisplaySearchItem {
    my ($in_list_hash) = @_;

    # 画面の下地の作成
    my $FRM03 = MainWindow->new();
    my $FRM03_TITLE = $FRM03->Label(-text => 'JSONファイル検索結果')->pack();
    my $FRM03_ROW = $FRM03->Frame();
    my $FRM03_FOOTER = $FRM03->Frame();

    # 検索結果をリスト表示
    # # 列1：チェックボックス
    # # 列2：番号
    # # 列3：モンスター名
    # my $list_sz = scalar(@key_list);
    # my $FRM03_tbl01 = $FRM03->Table(-rows => $list_sz,
    #                                 -columns => 3,
    #                                 -scrollbars => 'se',
    #                                 );
    my @key_list = keys(%{$in_list_hash});
    my $FRM03_TBL01 = $FRM03->Table(-rows => 10, -columns => 3, -scrollbars => 'e',);
    my $row = 0;
    foreach my $item_num (sort(@key_list)) {
        # my $row_chkbox = $FRM03_ROW->Checkbutton()->grid(-row => $row, -column => 0);
        # my $row_number = $FRM03_ROW->Label(-text => $item_num, -anchor => 'w')->grid(-row => $row, -column => 1);
        # my $row_name   = $FRM03_ROW->Label(-text => $$in_list_hash{$item_num}, -anchor => 'w')->grid(-row => $row, -column => 2);
        my $FRM03_CHK01 = $FRM03_TBL01->Checkbutton();
        $FRM03_TBL01->put($row, 0, $FRM03_CHK01);
        $FRM03_TBL01->put($row, 1, $item_num);
        $FRM03_TBL01->put($row, 2, $$in_list_hash{$item_num});
        $row++;
    }
    # $FRM03_tbl01->pack(-fill => 'both', -expand => 1,);
    # my $FRM03_SEARCH = $FRM03_FOOTER->Button(-text => '検索',)->pack(-side => 'left');
    # my $FRM03_EXIT = $FRM03_FOOTER->Button(-text => '終了', -command => \&exit)->pack(-side => 'left');

    # $FRM03->pack();
    # $FRM03_ROW->pack(-fill => 'both');
    $FRM03_TBL01->pack(-fill => 'both');
    # $FRM03_FOOTER->pack(-fill => 'both');

    my $FRM03_SEARCH = $FRM03->Button(-text => '検索',)->pack(-side => 'left');
    my $FRM03_EXIT = $FRM03->Button(-text => '終了', -command => \&exit)->pack(-side => 'left');

    MainLoop();
}
# メインウィンドウ
my $TOP = MainWindow->new();
my $TOP_TITLE = $TOP->Label(-text => 'JSONデータ')->pack();
my $LBL01 = $TOP->Label(-text => '番号を入力して下さい。')->pack();
my $TBX01 = $TOP->Entry(-text => '')->pack();
my $LBL02 = $TOP->Label(-text => '名前を入力して下さい。')->pack();
my $TBX02 = $TOP->Entry(-text => '')->pack();
my $FRM01_F0 = $TOP->Frame();
my $BTN01 = $FRM01_F0->Button(-text => '検索', -command => [\&Form01_CheckInput, $TBX01, $TBX02])->pack(-side => 'left');
my $BTN02 = $FRM01_F0->Button(-text => '終了', -command => \&exit)->pack(-side => 'left');
$FRM01_F0->pack();
MainLoop();

