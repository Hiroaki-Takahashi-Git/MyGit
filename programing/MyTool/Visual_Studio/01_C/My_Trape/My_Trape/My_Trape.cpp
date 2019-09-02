// My_Trape.cpp : このファイルには 'main' 関数が含まれています。プログラム実行の開始と終了がそこで行われます。
//

#include "pch.h"
#include <iostream>

using namespace std;

int main(int argc, char **argv)
{
    //std::cout << "Hello World!\n";
	double h;	/*刻み幅*/
	double integral;	/*積分値*/
	int n;
	int i;

	/*分割数Nの初期化*/
	if (argc < 2)
	{/*区間分割数 Nの指定がない*/
		fprintf(stderr, "使い方 My_Trape (区間分割数N)\n");
		return 1;
	}

	/*刻み幅hの計算*/
	if ((n=atoi(argv[1])) <= 0)
	{
		fprintf(stderr, "区間分割数Nが不正です(%d)\n", n);
		return 1;
	}
	h = 1.0 / n;

	/*積分値の計算*/
	integral = fx(0.0) / 2.0;
	for (i = 0; i < n; i++)
	{
		integral += fx((double)i/n);
	}
	integral += fx(1.0) / 2.0;
	integral *= h;

	/*結果の出力*/
	printf("積分値I %.9lf	4I %.9lf\n", integral, integral * 4.0);

	return 0;
}

double fx(double x)
{
	return sqrt(1.0 - x*x);
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
