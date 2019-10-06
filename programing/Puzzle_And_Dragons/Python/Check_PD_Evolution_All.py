#coding:    cp932
import sys
from time import sleep

Module01 = __import__('Set_PD_Constant')
Module02 = __import__('Set_PD_Number')
Module03 = __import__('01_Get_URL')
MyModule = __import__('Check_PD_Evolution')

args = sys.argv
ROOT_DPATH	=	args[1]
STRT_NUMSTR	=	args[2]
STOP_NUMSTR	=	args[3]

def main(INPUT_PATH, START, STOP):
    pass
    # 取得する全データの総数の確認
    total = int(STOP) - int(START) + 1
    cnt = 1
    for ID in range(int(START), int(STOP) + 1):
        print('{0}({1}/{2})'.format('%d' % ID, '%d' % cnt, '%d' % total))
        # 5ミリ秒だけ時間を空ける
        sleep(0.01)

        #URLの確認
        HTTP = Module02.SET_PDNUM(ID)
        RESP = Module03.GET_URL_DATA(HTTP)
        # print(RESP)
        if RESP is not "NODATA":
            # モンスターの進化を確認する
            MyModule.main(ROOT_DPATH, ID)
        # cnt を更新
        cnt = cnt + 1

if __name__ == "__main__":
    pass
    main(ROOT_DPATH, STRT_NUMSTR, STOP_NUMSTR)