#coding:    cp932
import sys

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
    for ID in range(int(START), int(STOP) + 1):
        print(ID)
        #URLの確認
        HTTP = Module02.SET_PDNUM(ID)
        RESP = Module03.GET_URL_DATA(HTTP)
        # print(RESP)
        if RESP is not "NODATA":
            # モンスターの進化を確認する
            MyModule.main(ROOT_DPATH, ID)

if __name__ == "__main__":
    pass
    main(ROOT_DPATH, STRT_NUMSTR, STOP_NUMSTR)