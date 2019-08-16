// My_N-body.cpp : このファイルには 'main' 関数が含まれています。プログラム実行の開始と終了がそこで行われます。
//

#include "pch.h"
#include "com_func.h"
#include "my01_struct_star.h"
#include "my02_func_star.h"

using namespace std;

int main(int argc, char **argv)
{
    //std::cout << "Hello World!\n";
	string INPUT;
	float DT;
	int STEP, MAXSTEP;
	float RTN;
	ifstream ifs;
	vector<star_inf> VEC_CUR_STAR_INF;
	vector<star_inf> VEC_NEW_STAR_INF;
	star_inf rd_star;

	//引数から入力
	INPUT = argv[1];
	DT = atof(argv[2]);
	MAXSTEP = atoi(argv[3]);

	//cout << "input:" << INPUT << endl;
	//cout << "DT = " << DT << endl;

	RTN = 0;

	//データを読み取り
	RTN = read_data(INPUT, VEC_CUR_STAR_INF);

	//天体の位置と速度の時間変化を計算
	STEP = 0;
	while (STEP < MAXSTEP)
	{
		std::cout << "STEP:" << STEP << std::endl;

		//加速度を計算
		RTN = calc_acc(VEC_CUR_STAR_INF);

		//天体の情報を更新
		//RTN = calc_acc(VEC_CUR_STAR_INF);
		RTN = update_inf(DT, VEC_CUR_STAR_INF, VEC_NEW_STAR_INF);

		//天体の座標を入れ替える
		for (int i = 0; i < (int)VEC_CUR_STAR_INF.size(); i++)
		{
			memcpy_s(&VEC_CUR_STAR_INF.at(i), sizeof(star_inf), &VEC_NEW_STAR_INF.at(i), sizeof(star_inf));
		}

		STEP++;
	}

	VEC_CUR_STAR_INF.clear();
	VEC_NEW_STAR_INF.clear();

	return 0;
}

// プログラムの実行: Ctrl + F5 または [デバッグ] > [デバッグなしで開始] メニュー
// プログラムのデバッグ: F5 または [デバッグ] > [デバッグの開始] メニュー

// 作業を開始するためのヒント: 
//    1. ソリューション エクスプローラー ウィンドウを使用してファイルを追加/管理します 
//   2. チーム エクスプローラー ウィンドウを使用してソース管理に接続します
//   3. 出力ウィンドウを使用して、ビルド出力とその他のメッセージを表示します
//   4. エラー一覧ウィンドウを使用してエラーを表示します
//   5. [プロジェクト] > [新しい項目の追加] と移動して新しいコード ファイルを作成するか、[プロジェクト] > [既存の項目の追加] と移動して既存のコード ファイルをプロジェクトに追加します
//   6. 後ほどこのプロジェクトを再び開く場合、[ファイル] > [開く] > [プロジェクト] と移動して .sln ファイルを選択します
