use utf8;
use warnings;
use strict;
use Tk;
use Tk::jpeg;
use Tk::png;
use JSON;
use File::Slurp;
use File::Basename 'basename', 'dirname';
use File::Path 'mkpath';

require '.\PDDefine\PD02_Define.pm';
require '.\PDForm01\PD02_Form01.pm';
require '.\PDForm04\PD02_Form04.pm';

# my @Frm02_Arr = ();

sub Form02_Func01_Main {
    my ($IN_NUMBER) = @_;

    my $JSON_FNAME = sprintf("%s\\PDMonster%06d\\PDMonster%06d.json",   &Define_Item('PD_DATADIR'),
                                                                        $IN_NUMBER,
                                                                        $IN_NUMBER);

    # JSONファイルのチェック
    my $ret = &Form02_Func02_CheckFileExist($JSON_FNAME);
    if ($ret == 0) {
        # JSONファイルの読み取り
        my $JSON_HASH = &Form02_Func03_ReadJSONFile($JSON_FNAME);

        # JSONデータの表示
        &Form02_Func05_DisplayGetItem($JSON_HASH);
    }
    else {
        # JSONファイルの作成
        # ディレクトリ名の取得
        my $JSON_DNAME = dirname $JSON_FNAME;
        print "Make Directory : $JSON_DNAME\n";
        mkpath($JSON_DNAME);

        # WEBデータから取得
        my $PY_MODULE = sprintf("%s\\Extract_PD_Data.py", &Define_Item('TOOL_PYTHON'));
        open(COM, "|python $PY_MODULE $IN_NUMBER $JSON_FNAME");
        close(COM);

        # 自身の関数を呼び出し
        &Form02_Func01_Main($IN_NUMBER);
    }
}

sub Form02_Func02_CheckFileExist {
    my ($FNAME) = @_;
    my $ret = 0;
    if (! -f $FNAME)
    {
        $ret = 1;
    }
    return $ret;
}

sub Form02_Func03_ReadJSONFile {
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

sub Form02_Func04_GetJSONData {
    my ($in_hash, $str) = @_;
    my @key_list = keys(%{$in_hash});
    my %output_hash;
    my %output_hash2;
    foreach my $key (@key_list) {
        my $val = $in_hash->{$key};
        my $val_ref = ref($val);
        if ("$val_ref" eq 'HASH') {
            %output_hash2 = &Form02_Func04_GetJSONData($val, &Convert_String($str, $key));
            while (my ($key2, $val2) = each(%output_hash2)) {
                next if (grep {$_ eq $key2} keys(%output_hash));
                $output_hash{$key2} = $val2;
            }
        } else {
            my $cvrt_key = &Convert_String($str, $key);
            next if (grep {$_ eq $cvrt_key} keys(%output_hash));
            $output_hash{$cvrt_key} = $val;
        }
    }
    return (%output_hash);
}

sub Form02_Func05_DisplayGetItem {
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
    &Init_Form;
    my $FRM02 = MainWindow->new();
    $FRM02->optionAdd('*font' => ['', 14]);
    $FRM02->title('JSONファイル取得結果');
    my $FRM02_HEADER = $FRM02->Frame()->pack();
    my $FRM02_TITLE = $FRM02_HEADER->Label(-text => 'JSONファイル取得結果')->pack();
    # push(@Frm02_Arr, $FRM02);

    my %JSON_HASH2 = &Form02_Func04_GetJSONData($JSON_HASH, 'PD');
    my @JSON_KEY_ARR = keys(%JSON_HASH2);
  
    # 表示項目の設定
    my $FRM02_DISPMAIN01 = $FRM02->Frame()->grid(-row => 0, -column => 0)->pack(-padx => 10, -pady => 10);
    my $FRM02_DISPMAIN02 = $FRM02->Frame()->grid(-row => 0, -column => 1)->pack(-padx => 10, -pady => 10);

    # 番号
    $IN_STR = sprintf("PD\tnumber");
    my $LBL_NUM_VAL = $JSON_HASH2{$IN_STR};
    my $LF_NUMBER   = $FRM02_DISPMAIN01->Labelframe(-text => '番号',)->grid(-row => 0, -column => 0, -ipadx => 5, -ipady => 5, -columnspan => 1, -sticky => 'news');
    $LF_NUMBER->configure(-labelanchor => 'nw');
    my $PD_NUMBER_VAL = $LF_NUMBER->Label(-text => "$LBL_NUM_VAL",)->pack();

    # 名前
    $IN_STR = sprintf("PD\tname");
    my $LF_NAME = $FRM02_DISPMAIN01->Labelframe(-text => '名前', -width => 50, -height => 25)->grid(-row => 0, -column => 1, -ipadx => 5, -ipady => 5, -columnspan => 3, -sticky => 'news');
    $LF_NAME->configure(-labelanchor => 'nw');
    my $LBL_NAME_VAL = $JSON_HASH2{$IN_STR};
    my $PD_NAME_VAL = $LF_NAME->Label(-text => "$LBL_NAME_VAL",)->pack();

    # レア
    $IN_STR = sprintf("PD\trare");
    my $LF_RARE = $FRM02_DISPMAIN01->Labelframe(-text => 'レア度', -width => 50, -height => 25)->grid(-row => 1, -column => 0, -ipadx => 5, -ipady => 5, -sticky => 'news');
    $LF_RARE->configure(-labelanchor => 'nw');
    my $LBL_RARE_VAL = $JSON_HASH2{$IN_STR};;
    my $PD_RARE_VAL = $LF_RARE->Label(-text => "$LBL_RARE_VAL", -width => 25,)->pack();

    # コスト
    $IN_STR = sprintf("PD\tcost");
    my $LF_COST = $FRM02_DISPMAIN01->Labelframe(-text => 'コスト', -width => 50, -height => 25)->grid(-row => 2, -column => 0, -ipadx => 5, -ipady => 5, -sticky => 'news');
    $LF_COST->configure(-labelanchor => 'nw');
    my $LBL_COST_VAL = $JSON_HASH2{$IN_STR};
    my $PD_COST_VAL = $LF_COST->Label(-text => "$LBL_COST_VAL", -width => 25,)->pack();

    # アシスト
    $IN_STR = sprintf("PD\tassistance");
    my $LF_ASSIST = $FRM02_DISPMAIN01->Labelframe(-text => 'アシスト', -width => 50, -height => 25)->grid(-row => 1, -column => 3, -ipadx => 5, -ipady => 5, -sticky => 'news');
    $LF_ASSIST->configure(-labelanchor => 'nw');
     my $LBL_Assist_VAL = $JSON_HASH2{$IN_STR};
    if ($LBL_Assist_VAL == 0) {
        $LBL_Assist_VAL = "不可";
    } else {
        $LBL_Assist_VAL = "可";
    }
    my $PD_Assist_VAL = $LF_ASSIST->Label(-text => "$LBL_Assist_VAL", -width => 25,)->pack();

    # 属性
    my $LF_ATTR = $FRM02_DISPMAIN01->Labelframe(-text => '属性', -width => 50, -height => 25)->grid(-row => 1, -column => 1, -ipadx => 5, -ipady => 5, -rowspan => 2, -sticky => 'news');
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
    my $LF_TYPE = $FRM02_DISPMAIN01->Labelframe(-text => 'タイプ')->grid(-row => 1, -column => 2, -ipadx => 5, -ipady => 5, -rowspan => 2, -sticky => 'news');
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
    my $LF_SKILL1 = $FRM02_DISPMAIN01->Labelframe(-text => $item_hash{'skills'})->grid(-row => 4, -column => 0, -ipadx => 5, -ipady => 5, -rowspan => 2, -columnspan => 4, -sticky => 'news');
    $LF_SKILL1->configure(-labelanchor => 'nw');
    my @skill_item_list = ('スキル', 'リーダースキル');
    my @skill_contents_list = ('名前', 'タイプ', '内容');
    my $s_cnt = 0;
    foreach my $s_item (@skill_item_list) {
        my $s_row = $s_cnt / 2;
        my $s_col = $s_cnt % 2;
        my $LF_SKILL2 = $LF_SKILL1->Labelframe(-text => $s_item,)->grid(-row => $s_row, -column => $s_col, -padx => 5, -pady => 5, -sticky => 'news');
        $LF_SKILL2->configure(-labelanchor => 'nw');
        my $s_cnt2 = 0;
        foreach my $s_content (@skill_contents_list) {
            $IN_STR = sprintf("PD\tskills\t%s\t%s", $s_item, $s_content);
            my $s_cnt_row2 = $s_cnt2 % 3;
            # print "IN_STR\t", encode('Shift_JIS', $IN_STR), "\n";
            my $LF_S_FRM = $LF_SKILL2->Frame()->grid(-row => $s_cnt_row2, -column => 0, -padx => 5, -pady => 5, -sticky => 'news');
            my $PD_CONTENT_VAL;
            if ($s_content eq 'タイプ') {
                my $s_type_cnt = 0;
                my @s_type_arr = ();
                foreach my $s_key (@JSON_KEY_ARR) {
                    if ($s_key =~ /$IN_STR\ttype\d+/) {
                        my $PD_S_TYPE_VAL = $JSON_HASH2{$s_key};
                        push(@s_type_arr, $PD_S_TYPE_VAL);
                    }
                }
                if (scalar(@s_type_arr) > 0) {
                    my $s_type_strage = 3;
                    for (my $i = 0; $i < scalar(@s_type_arr); $i++) {
                        my $s_type_r = $i / $s_type_strage;
                        my $s_type_c = $i % $s_type_strage;
                        my $PD_SKILL_TYPE = $LF_S_FRM->Label(-text => "$s_type_arr[$i]", -anchor => 'w')->grid(-row => $s_type_r, -column => $s_type_c, -padx => 5, -pady => 5, -sticky => 'news');
                    }
                } else {
                    my $PD_SKILL_TYPE = $LF_S_FRM->Label(-text => "NODATA", -anchor => 'w')->pack(-padx => 5, -pady => 5);
                }
            } elsif ($s_content eq '名前') {
                if (grep {$_ eq $IN_STR} @JSON_KEY_ARR) {
                    $PD_CONTENT_VAL = $JSON_HASH2{$IN_STR};
                    $LF_S_FRM->Label(-text => "$PD_CONTENT_VAL", -anchor => 'w')->pack(-padx => 5, -pady => 5);
                } else {
                    $LF_S_FRM->Label(-text => "NODATA", -anchor => 'w')->pack(-padx => 5, -pady => 5);
                }
            } else {
                if (grep {$_ eq $IN_STR} @JSON_KEY_ARR) {
                    $PD_CONTENT_VAL = $JSON_HASH2{$IN_STR};
                    my @PD_STR_ARR = split(/。/, $PD_CONTENT_VAL);
                    for (my $i = 0; $i < scalar(@PD_STR_ARR); $i++) {
                        my $PD_STRING = sprintf("%s。", $PD_STR_ARR[$i]);
                        my $PD_SKILL_CONTENT = $LF_S_FRM->Label(-text => $PD_STRING, -anchor => 'w')->grid(-row => $i, -column => 0, -ipadx => 5, -ipady => 5, -rowspan => 1, -columnspan => 3, -sticky => 'news');
                    }
                } else {
                    $LF_S_FRM->Label(-text => "NODATA", -anchor => 'w')->pack(-padx => 5, -pady => 5);
                }
            }
            $s_cnt2++;
        }
        $s_cnt++;
    }
    
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
            my $PD_PARA_ROW = $LF_PARA->Label(-text => $p_item, -anchor => 'e')->grid(-row => $p_row+1, -column => 0, -ipadx => 5, -pady => 5, -sticky => 'news');
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
            $killer_item =~ s/$IN_STR\t//;
            my $PD_KILLER_ITEM = $LF_KILLER->Label(-text => "$killer_item", -anchor => 'w')->grid(-row => $killer_item_row, -column => 0, -ipadx => 5, -ipady => 5);
            my $PD_KILLER_CNT = $LF_KILLER->Label(-text => "$killer_cnt", -anchor => 'w')->grid(-row => $killer_item_row, -column => 1, -ipadx => 5, -ipady => 5);
            $killer_item_row++;
        }
    }

    # ボタンの設定
    my $FRM02_SUB99 = $FRM02->Frame()->pack(-padx => 10, -pady => 10);
    my $BTN01 = $FRM02_SUB99->Button(-text => '戻る', -command => [\&Form02_Func06_ReDisplay],)->grid(-row => 0, -column => 0);
    my $BTN02 = $FRM02_SUB99->Button(-text => '進化', -command => [\&Form02_Func07_SearchEvolution, $LBL_NUM_VAL, $LBL_NAME_VAL])->grid(-row => 0, -column => 1);
    my $BTN03 = $FRM02_SUB99->Button(-text => '分析', -command => [\&Form04_Func01_Main, $LBL_NUM_VAL, $LBL_NAME_VAL])->grid(-row => 0, -column => 2);
    my $BTNE = $FRM02_SUB99->Button(-text => '終了', -command => \&exit,)->grid(-row => 0, -column => 9);
    MainLoop();

    &Add_Form($FRM02);

    # 画像
    my $PD_IMG_FNAME = sprintf("%s\\PDMonster%06d\\PDMonster%06d.jpg", &Define_Item('PD_DATADIR'), $JSON_HASH2{"PD\tnumber"}, $JSON_HASH2{"PD\tnumber"});
    &Form02_Func08_DisplayImage($PD_IMG_FNAME);
}

sub Form02_Func06_ReDisplay {
    # my ($Frm02_Arr) = @_;

    # foreach my $frm (@{$Frm02_Arr}) {
    #     $frm->withdraw;
    # }

    &Form01_Func01_Main();
}

sub Form02_Func07_SearchEvolution {
    my ($IN_NUMBER, $IN_NAME) = @_;
    print &Define_Item('PD_EVODIR'), "\n";
    my $msg = sprintf("%s の進化検索開始", $IN_NAME);
    print encode('Shift_JIS', $msg), "\n";

    # Pythonモジュールの設定
    my $PY_MODULE = sprintf("%s\\Check_PD_Evolution.py", &Define_Item('TOOL_PYTHON'));

    # 出力先ディレクトリの設定
    my $PD_PRODDIR = &Define_Item('PD_EVODIR');

    # 進化検索処理の開始
    # 画像
    my $PD_IMG_FNAME = sprintf("%s\\PDMonster%06d.png", $PD_PRODDIR, $IN_NUMBER);
    # my $PD_IMAGE = $FRM02_DISPMAIN02->Photo(-format => 'jpeg', -file => "$PD_IMG_FNAME");

    # ファイルが存在するか確認
    my $ret = &Form02_Func02_CheckFileExist($PD_IMG_FNAME);
    if ($ret >= 0) {
        open(COM, "|python $PY_MODULE $PD_PRODDIR $IN_NUMBER") or die "Error!!";
        close(COM);
    }

    print encode('Shift_JIS', "検索終了"), "\n";

    # 画像を表示
    &Form02_Func08_DisplayImage($PD_IMG_FNAME);
}

sub Form02_Func08_DisplayImage {
    my ($IN_IMG_FNAME) = @_;

    my $ret = &Form02_Func02_CheckFileExist($IN_IMG_FNAME);
    if ($ret == 0)
    {
        # &Init_Form;

        my ($base, $ext) = split(/\./, $IN_IMG_FNAME);

        # 画像ファイルの表示
        my $PD_IMG_FRM = MainWindow->new();
        $PD_IMG_FRM->optionAdd('*font' => ['', 14]);
        $PD_IMG_FRM->title('画像');
        my $PD_IMG_DATA;
        if ($ext eq 'png') {
            $PD_IMG_DATA = $PD_IMG_FRM->Photo(-format => 'png', -file => "$IN_IMG_FNAME");
        }
        elsif ($ext eq 'jpg' || $ext eq 'jpeg') {
            $PD_IMG_DATA = $PD_IMG_FRM->Photo(-format => 'jpeg', -file => "$IN_IMG_FNAME");
        }
        $PD_IMG_FRM->Label(-image => $PD_IMG_DATA)->pack();
        &Add_Form($PD_IMG_FRM);

        # ボタンの設定
        my $FRM02_SUB99 = $PD_IMG_FRM->Frame()->pack(-padx => 10, -pady => 10);
        my $BTN01 = $FRM02_SUB99->Button(-text => '戻る', -command => [\&Form02_Func06_ReDisplay],)->grid(-row => 0, -column => 0);
        my $BTNE = $FRM02_SUB99->Button(-text => '終了', -command => \&exit,)->grid(-row => 0, -column => 9);

        MainLoop();
    }
}

1;
