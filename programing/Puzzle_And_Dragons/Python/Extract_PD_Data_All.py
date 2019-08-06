#coding:	cp932
import sys

CoModule01 = __import__('04_Make_Directory')
MyModule01 = __import__('Extract_PD_Data')
MyModule02 = __import__('Check_PD_Evolution')

args = sys.argv
ROOT_DPATH	=	args[1]
STRT_NUMSTR	=	args[2]
STOP_NUMSTR	=	args[3]

def main(INPUT_PATH, START, STOP):
	pass
	#STRT ～ STOPの間のモンスター番号の情報を取得する
	for ID in range(int(START), int(STOP) + 1):
		IDX = '%06d' % ID
		IDXSTR = str(IDX)
		
		#モンスター毎にディレクトリの作成
		BASENAME = INPUT_PATH + '\\' + "PDMonster" + IDXSTR
		CoModule01.MKDIR(BASENAME)
		
		#情報の取得
		F_NAME = BASENAME + '\\' + "PDMonster" + IDXSTR + ".tsv"
		print(F_NAME)
		RTN = MyModule01.main(ID, F_NAME)
		#print(RTN)
		#情報取得が失敗したら、スキップ
		if RTN is "FAILURE":
			continue

		#進化の系統情報の取得
		#MyModule02.main(ID)
		
if __name__=="__main__":
    main(ROOT_DPATH, STRT_NUMSTR, STOP_NUMSTR)
