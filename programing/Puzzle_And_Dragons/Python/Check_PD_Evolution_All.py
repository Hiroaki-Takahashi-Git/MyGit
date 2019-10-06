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
    # �擾����S�f�[�^�̑����̊m�F
    total = int(STOP) - int(START) + 1
    cnt = 1
    for ID in range(int(START), int(STOP) + 1):
        print('{0}({1}/{2})'.format('%d' % ID, '%d' % cnt, '%d' % total))
        # 5�~���b�������Ԃ��󂯂�
        sleep(0.01)

        #URL�̊m�F
        HTTP = Module02.SET_PDNUM(ID)
        RESP = Module03.GET_URL_DATA(HTTP)
        # print(RESP)
        if RESP is not "NODATA":
            # �����X�^�[�̐i�����m�F����
            MyModule.main(ROOT_DPATH, ID)
        # cnt ���X�V
        cnt = cnt + 1

if __name__ == "__main__":
    pass
    main(ROOT_DPATH, STRT_NUMSTR, STOP_NUMSTR)