#coding:	cp932
from bs4 import BeautifulSoup
from urllib import request
import sys
import types
import os
import numpy as np
import re
import requests
import codecs
import texttable as ttb

#自作の関数
module01 = __import__('01_Get_URL')
module02 = __import__('Set_PD_Constant')
module03 = __import__('Set_PD_Number')
module04 = __import__('03_Make_2DMatrix')

#コマンドライン引数
args = sys.argv
PD_NUMBER	=	args[1]

#モンスターのパラーメータを取得する
def PD_GET_STATUS(IN_TAG):
	PD_STATUS = IN_TAG.find('table', attrs={'class', 'table-monster-status'})
	CELL_ALL = PD_STATUS.find_all(['td', 'th'])
	ROWS_ALL = PD_STATUS.find_all('tr')
	CELL_SIZ = len(CELL_ALL)
	ROWS_SIZ = len(ROWS_ALL)
	COLS_SIZ = int(CELL_SIZ / ROWS_SIZ)
	CELL_ARR = []
	COL_ARR2 = []
	ROW_ARR2 = []
	CELL_ARR2 = []
	for CELL in CELL_ALL:
		ELEM_STR = CELL.get_text(strip=True)
		CELL_ARR.append(ELEM_STR)
	for i in range(0, COLS_SIZ):
		for j in range(0, ROWS_SIZ):
			IDX = j * COLS_SIZ + i
			CELL_ARR2.append(CELL_ARR[IDX])
	#print(COL_ARR2)
	#print(ROW_ARR2)
	#CELL_ARR2 = COL_ARR2.extend(ROW_ARR2)
	#print(CELL_ARR2)
	#return CELL_ARR, COLS_SIZ
	return CELL_ARR2, ROWS_SIZ

def main(NUMBER):
    pass
    PD_HTTP = module03.SET_PDNUM(NUMBER)
    PD_URL = module01.GET_URL_DATA(PD_HTTP)
    TEST_ARR, TEST_C = PD_GET_STATUS(PD_URL)
    PD_TBL = ttb.Texttable()
    #PD_TBL = PD_MAKE_MATRIX(TEST_ARR, TEST_R, TEST_C)
    #PD_TBL = module04.MAKE_MATRIX(TEST_ARR, TEST_R, TEST_C)
    #print(TEST_ARR)
    #print(TEST_R)
    #print(TEST_C)
    print(PD_TBL.draw() + "\n")

if __name__=="__main__":
    main(PD_NUMBER)
