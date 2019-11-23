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
use File::Basename 'basename', 'dirname';
use File::Path 'mkpath';

my $PD_ROOTDIR  = "F:\\Puzzle_and_Dragons";
my $PD_DATADIR  = sprintf("%s\\PD_Data", $PD_ROOTDIR);
my $PD_TOOLDIR  = "F:\\MyGit\\programing\\Puzzle_And_Dragons";
my $TOOL_PERL   = sprintf("%s\\Perl", $PD_TOOLDIR);
my $TOOL_PYTHON = sprintf("%s\\Python", $PD_TOOLDIR);

my $INPUT_NUM = "";
my $TOP;
my $Form02;
my $Form03;

# メインウィンドウ
&MAIN;

# ここから関数群
sub MAIN {
    $TOP = MainWindow->new();
    $TOP->optionAdd('*font' => ['', 14]);
    my $TOP_TITLE = $TOP->Label(-text => 'JSONデータ')->pack();
    my $FRM01_F0 = $TOP->Frame(-width => 640, -height => 480);
    my $LBL01 = $FRM01_F0->Label(-text => '番号を入力して下さい。',)->pack(-fill => 'x', -padx => 10, -pady => 10);
    my $TBX01 = $FRM01_F0->Entry(-text => '')->pack();
    my $LBL02 = $FRM01_F0->Label(-text => '名前を入力して下さい。',)->pack(-fill => 'x', -padx => 10, -pady => 10);
    my $TBX02 = $FRM01_F0->Entry(-text => '')->pack();
    my $FRM01_F1 = $TOP->Frame();
    my $BTN01 = $FRM01_F1->Button(-text => '検索', -command => [\&Form01_Func01_CheckInput, $TBX01, $TBX02],)->pack(-side => 'left', -padx => 10, -pady => 10);
    my $BTN02 = $FRM01_F1->Button(-text => '終了', -command => \&exit,)->pack(-side => 'left', -padx => 10, -pady => 10);
    $FRM01_F0->pack();
    $FRM01_F1->pack();

    MainLoop();
}

sub Form01_Func01_CheckInput {
    my ($TBX1, $TBX2) = @_;

    my $tbx1_val = $TBX1->get;
    my $tbx2_val = $TBX2->get;

    my $msg = "エラーメッセージ";

    # 先に開いているフレームを消す
    if (Exists($TOP)) {
        $TOP->withdraw;
    }

    if ($tbx1_val eq '' && $tbx2_val eq '') {
        $msg = "数字か検索ワードを入力して下さい。";
        print encode('Shift_JIS', $msg), "\n";
        $TOP->deiconify;
    } elsif ($tbx1_val eq '' && $tbx2_val ne '') {
        # 検索ワードを含むモンスター名を検索
        &Form03_Main($tbx2_val);
    } else {
        if ($tbx1_val =~ /^\d+$/) {
            &Form02_Main($tbx1_val);
        } else {
            $msg = "全部数字で入力して下さい。";
            print encode('Shift_JIS', $msg), "\n";
            $TOP->deiconify;
        }
    }
}

sub Form02_Main {
    my ($IN_NUMBER) = @_;

    my $JSON_FNAME = sprintf("%s\\PDMonster%06d\\PDMonster%06d.json", $PD_DATADIR, $IN_NUMBER, $IN_NUMBER);

    # JSONファイルのチェック
    my $ret = &Form02_Func01_CheckJSONFile($JSON_FNAME);
    if ($ret == 0) {
        # JSONファイルの読み取り
        my $JSON_HASH = &Form02_Func02_ReadJSONFile($JSON_FNAME);

        # JSONデータの表示
        &Form02_Func04_DisplayGetItem($JSON_HASH);
    }
    else {
        # JSONファイルの作成
        # ディレクトリ名の取得
        my $JSON_DNAME = dirname $JSON_FNAME;
        print "Make Directory : $JSON_DNAME\n";
        mkpath($JSON_DNAME);

        # WEBデータから取得
        my $PY_MODULE = sprintf("%s\\Extract_PD_Data.py", $TOOL_PYTHON);
        open(COM, "|python $PY_MODULE $IN_NUMBER $JSON_FNAME");
        close(COM);

        # 自身の関数を呼び出し
        &Form02_Main($IN_NUMBER);
    }
}
sub Form02_Func01_CheckJSONFile {
    my ($FNAME) = @_;
    my $ret = 0;
    if (! -f $FNAME)
    {
        $ret = 1;
    }
    return $ret;
}

sub Form02_Func02_ReadJSONFile {
    my ($FNAME) = @_;

    my $json_data = File::Slurp::read_file($FNAME);
    my $json = JSON::decode_json($json_data);

    return ($json);
}

sub Convert_String {
    my ($str1, $str2) = @_;
    if ($str1 eq '') {
        return (sprintf("%s", $str2));
    } else {
        return (sprintf("%s\t%s", $str1, $str2));
    }
}

sub Form02_Func03_GetJSONData {
    my ($in_hash, $str) = @_;
    my @key_list = keys(%{$in_hash});
    my %output_hash;
    my %output_hash2;
    foreach my $key (@key_list) {
        my $val = $in_hash->{$key};
        my $val_ref = ref($val);
        if ("$val_ref" eq 'HASH') {
            %output_hash2 = &Form02_Func03_GetJSONData($val, &Convert_String($str, $key));
            while (my ($key2, $val2) = each(%output_hash2)) {
                # print "key2 : ", encode('Shift_JIS', $key2), "\t";
                # print "val2 : ", encode('Shift_JIS', $val2), "\n";
                next if (grep {$_ eq $key2} keys(%output_hash));
                $output_hash{$key2} = $val2;
            }
        } else {
            my $cvrt_key = &Convert_String($str, $key);
            # print "key1 : ", encode('Shift_JIS', $cvrt_key), "\t";
            # print "val1 : ", encode('Shift_JIS', $val), "\n";
            next if (grep {$_ eq $cvrt_key} keys(%output_hash));
            $output_hash{$cvrt_key} = $val;
        }
        # %output_hash = (%output_hash1, %output_hash2);
    }
    # while (my ($key, $val) = each(%output_hash)) {
    #     print "key3 : ", encode('Shift_JIS', $key), "\t";
    #     print "val3 : ", encode('Shift_JIS', $val), "\n";
    # }
    return (%output_hash);
}

sub Form02_Func04_DisplayGetItem {
    my ($JSON_HASH) = @_;

    my $IN_STR = "";

    my $LBL_DAT;
    my $LBL_STR;

    my @item_list = ('number', 'name', 'rare', 'cost', 'assistance');
    my %item_hash = ('number' => '番号',
                     'name' => '名前',
                     'rare' => 'レア度',
                     'cost' => 'コスト',
                     'assistance' => 'アシスト',
                     'attribute' => '属性',
                     'type' => 'タイプ',
                     'skills' => 'スキル関連',
                     'skill1' => 'モンスタースキル',
                     'skill2' => 'リーダースキル',
                     'parameters' => 'パラメータ',
                     'awake' => '覚醒関連',
                     'awake1' => '覚醒',
                     'awake2' => '超覚醒',
                     'killer' => 'キラー',
                     );

    # 画面の下地の作成
    my $FRM02 = MainWindow->new();
    $FRM02->optionAdd('*font' => ['', 14]);
    $FRM02->title('JSONファイル取得結果');
    my $FRM02_HEADER = $FRM02->Frame()->pack();
    my $FRM02_TITLE = $FRM02_HEADER->Label(-text => 'JSONファイル取得結果')->pack();

    my %JSON_HASH2 = &Form02_Func03_GetJSONData($JSON_HASH, 'PD');
    my @JSON_KEY_ARR = keys(%JSON_HASH2);
  
    # 表示項目の設定
    my $FRM02_DISPMAIN01 = $FRM02->Frame()->pack(-ipadx => 10, -ipady => 10, -fill => 'y');
    my $FRM02_DISPMAIN02 = $FRM02->Frame()->pack(-ipadx => 10, -ipady => 10, -fill => 'y');

    # 番号
    $IN_STR = sprintf("PD\tnumber");
    my $LBL_NUM_VAL = $JSON_HASH2{$IN_STR};
    my $LF_NUMBER   = $FRM02_DISPMAIN01->Labelframe(-text => '番号')->grid(-row => 0, -column => 0, -ipadx => 5, -ipady => 5, -sticky => 'news');
    $LF_NUMBER->configure(-labelanchor => 'nw');
    my $PD_NUMBER_VAL = $LF_NUMBER->Label(-text => "$LBL_NUM_VAL",)->pack();

    # 名前
    $IN_STR = sprintf("PD\tname");
    my $LF_NAME = $FRM02_DISPMAIN01->Labelframe(-text => '名前')->grid(-row => 0, -column => 1, -ipadx => 5, -ipady => 5, -columnspan => 2, -sticky => 'news');
    $LF_NAME->configure(-labelanchor => 'nw');
    my $LBL_NAME_VAL = $JSON_HASH2{$IN_STR};
    my $PD_NAME_VAL = $LF_NAME->Label(-text => "$LBL_NAME_VAL", -width => 25,)->pack();

    # レア
    $IN_STR = sprintf("PD\trare");
    my $LF_RARE = $FRM02_DISPMAIN01->Labelframe(-text => 'レア度')->grid(-row => 1, -column => 0, -ipadx => 5, -ipady => 5, -sticky => 'news');
    $LF_RARE->configure(-labelanchor => 'nw');
    my $LBL_RARE_VAL = $JSON_HASH2{$IN_STR};;
    my $PD_RARE_VAL = $LF_RARE->Label(-text => "$LBL_RARE_VAL", -width => 25,)->pack();

    # コスト
    $IN_STR = sprintf("PD\tcost");
    my $LF_COST = $FRM02_DISPMAIN01->Labelframe(-text => 'コスト')->grid(-row => 1, -column => 1, -ipadx => 5, -ipady => 5, -sticky => 'news');
    $LF_COST->configure(-labelanchor => 'nw');
    my $LBL_COST_VAL = $JSON_HASH2{$IN_STR};
    my $PD_COST_VAL = $LF_COST->Label(-text => "$LBL_COST_VAL", -width => 25,)->pack();

    # アシスト
    $IN_STR = sprintf("PD\tassistance");
    my $LF_ASSIST = $FRM02_DISPMAIN01->Labelframe(-text => 'アシスト')->grid(-row => 1, -column => 2, -ipadx => 5, -ipady => 5, -sticky => 'news');
    $LF_ASSIST->configure(-labelanchor => 'nw');
     my $LBL_Assist_VAL = $JSON_HASH2{$IN_STR};
    if ($LBL_Assist_VAL == 0) {
        $LBL_Assist_VAL = "不可";
    } else {
        $LBL_Assist_VAL = "可";
    }
    my $PD_Assist_VAL = $LF_ASSIST->Label(-text => "$LBL_Assist_VAL", -width => 25,)->pack();

    # 属性
    my $LF_ATTR = $FRM02_DISPMAIN01->Labelframe(-text => '属性')->grid(-row => 2, -column => 0, -ipadx => 5, -ipady => 5, -sticky => 'news');
    $LF_ATTR->configure(-labelanchor => 'nw');
    my @ATTR_LIST = ('火', '水', '木', '光', '闇');
    foreach my $attr (@ATTR_LIST) {
        $IN_STR = sprintf("PD\tattribute\t%s", $attr);
        my $LBL_ATTR_VAL = $JSON_HASH2{$IN_STR};
        if ($LBL_ATTR_VAL == 1) {
            my $PD_ATTR_VAL = $LF_ATTR->Label(-text => "$attr")->pack();
        }
    }

    # タイプ
    my $LF_TYPE = $FRM02_DISPMAIN01->Labelframe(-text => 'タイプ')->grid(-row => 2, -column => 1, -ipadx => 5, -ipady => 5, -sticky => 'news');
    $LF_TYPE->configure(-labelanchor => 'nw');
    my $REF_STR = sprintf("PD\ttype");
    foreach my $type_key (keys(%JSON_HASH2)) {
        next if ($type_key !~ /$REF_STR\t(\S+)/);
        my $REF_VAL = $JSON_HASH2{$type_key};
        if ($REF_VAL == 1) {
            my $PD_TYPE_VAL = $LF_TYPE->Label(-text => "$1")->pack();
        }
    }

    # スキル
    my $LF_SKILL1 = $FRM02_DISPMAIN01->Labelframe(-text => $item_hash{'skills'})->grid(-row => 3, -column => 0, -ipadx => 5, -ipady => 5, -columnspan => 2, -sticky => 'news');
    $LF_SKILL1->configure(-labelanchor => 'nw');
    my @skill_item_list = ('スキル', 'リーダースキル');
    my @skill_contents_list = ('名前', 'タイプ', '内容');
    my $s_row = 0;
    foreach my $s_item (@skill_item_list) {
        my $LF_SKILL2 = $LF_SKILL1->Labelframe(-text => $s_item,)->grid(-row => 0, -column => $s_row, -padx => 5, -pady => 5, -sticky => 'news');
        $LF_SKILL2->configure(-labelanchor => 'nw');
        foreach my $s_content (@skill_contents_list) {
            $IN_STR = sprintf("PD\tskills\t%s\t%s", $s_item, $s_content);
            if ($s_content eq 'タイプ') {
                my $s_type_lf = $LF_SKILL2->Labelframe(-relief => 'flat')->grid(-row => 1, -column => 0, -padx => 0, -pady => 0, -columnspan => 3, -sticky => 'news');
                my $s_type_cnt = 0;
                my $s_row_strage = 6;
                foreach my $s_key (@JSON_KEY_ARR) {
                    if ($s_key =~ /$IN_STR\ttype\d+/) {
                        my $s_type_r = $s_type_cnt / $s_row_strage;
                        my $s_type_c = $s_type_cnt % $s_row_strage;
                        my $PD_SKILL_TYPE = $s_type_lf->Label(-text => $JSON_HASH2{$s_key})->grid(-row => $s_type_r, -column => $s_type_c, -padx => 5, -pady => 5, -sticky => 'news');
                        $s_type_cnt++;
                    }
                }
            } else {
                if ($s_content eq '名前') {
                    my $PD_SKILL_NAME = $LF_SKILL2->Label(-text => $JSON_HASH2{$IN_STR}, -anchor => 'w')->grid(-row => 0, -column => 0, -ipadx => 5, -ipady => 5, -sticky => 'news');
                } else {
                    my $PD_SKILL_CONTENT = $LF_SKILL2->Label(-text => $JSON_HASH2{$IN_STR}, -anchor => 'w')->grid(-row => 2, -column => 0, -ipadx => 5, -ipady => 5, -sticky => 'news');
                }
            }
        }
        $s_row++;
    }
    
    # 画像
    # my $PD_IMG_FNAME = sprintf("%s\\PDMonster%06d\\PDMonster%06d.jpg", $PD_DATADIR, $JSON_HASH2{"PD\tnumber"}, $JSON_HASH2{"PD\tnumber"});
    # my $PD_IMAGE = $FRM02_DISPMAIN02->Photo(-file => "$PD_IMG_FNAME")->pack();

    # パラメータ
    my @para_content_list = ('HP', '攻撃', '回復');
    my @para_item_list = ('最大', 'プラス', '限界突破', '限界突破プラス');
    my $LF_PARA = $FRM02_DISPMAIN02->Labelframe(-text => $item_hash{'parameters'})->grid(-row => 0, -column => 0, -padx => 5, -pady => 5, -sticky => 'news');
    $LF_PARA->configure(-labelanchor => 'nw');
    my $p_cnt = 0;
    foreach my $p_content (@para_content_list) {
        my $p_col = $p_cnt / 3;
        my $PD_PARA_COL = $LF_PARA->Label(-text => $p_content)->grid(-row => 0, -column => $p_col + 1, -ipadx => 5, -pady => 5, -sticky => 'news');
        foreach my $p_item (@para_item_list) {
            my $p_row = $p_cnt % 4;
            $IN_STR = sprintf("PD\tparameters\t%s\t%s", $p_content, $p_item);
            my $PD_PARA_ROW = $LF_PARA->Label(-text => $p_item, -anchor => 'w')->grid(-row => $p_row+1, -column => 0, -ipadx => 5, -pady => 5, -sticky => 'news');
            my $PD_PARA_VAL = $LF_PARA->Label(-text => $JSON_HASH2{$IN_STR})->grid(-row => $p_row + 1, -column => $p_col + 1, -ipadx => 5, -pady => 5, -sticky => 'news');
            $p_cnt++;
        }
    }

    # 覚醒
    my @awake_content_list = ('awake1', 'awake2');
    my $LF_AWAKE = $FRM02_DISPMAIN02->Labelframe(-text => $item_hash{'awake'})->grid(-row => 0, -column => 1, -padx => 5, -pady => 5, -columnspan => 2, -sticky => 'news');
    $LF_AWAKE->configure(-labelanchor => 'nw');
    my $awake_col = 0;
    foreach my $awake_content (@awake_content_list) {
        my $LF_AWAKE2 = $LF_AWAKE->Labelframe(-text => $item_hash{$awake_content})->grid(-row => 0, -column => $awake_col, -padx => 5, -pady => 5, -sticky => 'news');
        $LF_AWAKE2->configure(-labelanchor => 'nw');
        $IN_STR = sprintf("PD\t$awake_content");
        my $awake_item_row = 0;
        foreach my $awake_item (@JSON_KEY_ARR) {
            if ($awake_item =~ /$IN_STR/) {
                my $awake_cnt = $JSON_HASH2{$awake_item};
                print encode('Shift_JIS', $awake_item), "\t";
                print "$awake_cnt\n";
                $awake_item =~ s/$IN_STR\t//;
                my $PD_AWAKE_ITEM = $LF_AWAKE2->Label(-text => "$awake_item", -anchor => 'w')->grid(-row => $awake_item_row, -column => 0, -ipadx => 5, -ipady => 5);
                my $PD_AWAKE_CNT = $LF_AWAKE2->Label(-text => "$awake_cnt", -anchor => 'w')->grid(-row => $awake_item_row, -column => 1, -ipadx => 5, -ipady => 5);
                $awake_item_row++;
            }
        }
        $awake_col++;
    }

    # キラー
    my $LF_KILLER = $FRM02_DISPMAIN02->Labelframe(-text => $item_hash{'killer'})->grid(-row => 0, -column => 3, -padx => 5, -pady => 5, -sticky => 'news');
    $LF_KILLER->configure(-labelanchor => 'nw');
    $IN_STR = sprintf("PD\tkiller");
    my $killer_item_row = 0;
    foreach my $killer_item (@JSON_KEY_ARR) {
        if ($killer_item =~ /$IN_STR/) {
            my $killer_cnt = $JSON_HASH2{$killer_item};
            print encode('Shift_JIS', $killer_item), "\t";
            print "$killer_cnt\n";
            $killer_item =~ s/$IN_STR\t//;
            my $PD_KILLER_ITEM = $LF_KILLER->Label(-text => "$killer_item", -anchor => 'w')->grid(-row => $killer_item_row, -column => 0, -ipadx => 5, -ipady => 5);
            my $PD_KILLER_CNT = $LF_KILLER->Label(-text => "$killer_cnt", -anchor => 'w')->grid(-row => $killer_item_row, -column => 1, -ipadx => 5, -ipady => 5);
            $killer_item_row++;
        }
    }

    # ボタンの設定
    my $FRM02_SUB99 = $FRM02->Frame()->pack(-padx => 10, -pady => 10);
    my $BTN01 = $FRM02_SUB99->Button(-text => '戻る', -command => [\&Form02_Func05_ReDisplay, $FRM02])->grid(-row => 0, -column => 0);
    my $BTN02 = $FRM02_SUB99->Button(-text => '終了', -command => \&exit,)->grid(-row => 0, -column => 1);
    MainLoop();
}

sub Form02_Func05_ReDisplay {
    my ($self_frm) = @_;
    # print "Check Start.\n";
    $self_frm->withdraw;
    if (!Exists($TOP)) {
        # print "Not Exist\n";
        # print encode('Shift_JIS', "メイン画面を開きます。"), "\n";
        &MAIN;
    }
    else {
        # print "Exists\n";
        $TOP->deiconify;
    }
}
sub Form03_Main {
    my ($IN_KEYSTR) = @_;

    # print encode('Shift_JIS', $IN_KEYSTR), "\n";
    my %FRM03_LIST = &Form03_Func01_SearchJSONName($IN_KEYSTR);

    # 検索結果を表示する
    &Form03_Func02_DisplaySearchResult(\%FRM03_LIST);
}

sub Form03_Func01_SearchJSONName {
    my ($IN_STR) = @_;

    my $msg = "メッセージ用";
    my %OUTPUT;

    $msg = "検索開始";
    print encode('Shift_JIS', $msg), "\n";
    opendir(DIR,  "$PD_DATADIR") or die "Error!!";
    my @LIST = readdir(DIR);
    foreach my $sub (@LIST) {
        next if ($sub =~ /^\.+$/);
        if ($sub =~ /^PDMonster\d+$/) {
            my $JSON_F = sprintf("%s\\%s\\%s.json", $PD_DATADIR, $sub, $sub);
            next if (! -f $JSON_F);
            my $JSON_HASH1 = &Form02_Func02_ReadJSONFile($JSON_F);

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

sub Form03_Func02_DisplaySearchResult {
    my ($IN_HASH) = @_;

    # 検索結果画面の生成
    my $FRM03  = MainWindow->new();
    $FRM03->optionAdd('*font' => ['', 14]);
    $FRM03->title('キーワード検索結果');
    my $FRM03_TITLE = $FRM03->Label(-text => 'キーワード検索結果')->pack(-fill => 'both');

    # リストボックスの生成
    my @KEY_LIST = sort(keys(%{$IN_HASH}));
    my $LIST_SZ = scalar(@KEY_LIST);
    my $FRM03_TBL01 = $FRM03->Table(-rows => 10, -columns => 3, -scrollbars => 'e',)->pack(-fill => 'x');
    for (my $i = 0; $i < $LIST_SZ; $i++) {
        my $PD_NUMBER  = $KEY_LIST[$i];
        my $PD_NAME = $$IN_HASH{$PD_NUMBER};
        my $FRM03_CHK01 = $FRM03_TBL01->Checkbutton(-onvalue => 1, -offvalue => 0, -command => [\&Form03_Func03_ReSearchJSONFile, $PD_NUMBER]);
        my $FRM03_LBL01 = $FRM03_TBL01->Label(-text => "$PD_NUMBER")->pack(-side => 'left');
        my $FRM03_LBL02 = $FRM03_TBL01->Label(-text => "$PD_NAME", -anchor => 'w')->pack();
        $FRM03_TBL01->put($i, 0, $FRM03_CHK01);
        $FRM03_TBL01->put($i, 1, $FRM03_LBL01);
        $FRM03_TBL01->put($i, 2, $FRM03_LBL02);
    }

    # ボタンの設定
    my $FRM03_SUB99 = $FRM03->Frame()->pack();
    # my $BTN01 = $FRM03_SUB99->Button(-text => '検索', -command => [\&Form03_Func03_ReSearchJSONFile, $FRM03_TBL01])->pack(-side => 'left');
    my $BTN02 = $FRM03_SUB99->Button(-text => '終了', -command => \&exit,)->pack(-side => 'left');
    MainLoop();
}

sub Form03_Func03_ReSearchJSONFile {
    my ($IN_NUMBER) = @_;

    $IN_NUMBER = sprintf("%d", $IN_NUMBER);

    # JSONファイル検索処理を実行
    &Form02_Main($IN_NUMBER);
}