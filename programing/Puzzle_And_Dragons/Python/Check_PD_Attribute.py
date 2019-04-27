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
import collections

#自作の関数
module01 = __import__('01_Get_URL')
module02 = __import__('Set_PD_Constant')
module03 = __import__('Set_PD_Number')
module04 = __import__('03_Make_2DMatrix')

#コマンドライン引数
args = sys.argv
PD_NUMBER	=	args[1]

#属性の有無
def PD_CHECK_RET(RET):
	if RET is not None:
		return '〇'
	else:
		return '×'

#属性の有無の文字列
def PD_MAKE_STR(ATTR, RET):
	RES_STR = ATTR + '－＞' + RET
	#print(RES_STR)
	return(RES_STR)
	
#モンスターの属性を確認する
def PD_CHECK_ATTRIBUTE(IN_TAG):
	ATTR_ARR = []
	#ATTR_COL = ["属　性", "〇／×"]
	#ATTR_ARR.extend(ATTR_COL)
	#火属性
	RET = IN_TAG.find('i', attrs={'class':'icon-attr-fire'})
	FLG = PD_CHECK_RET(RET)
	#RES_STR = PD_MAKE_STR('火', FLG)
	#ATTR_ARR.append(RES_STR)
	ATTR_ARR.append(FLG)
	#print(RET)
	#水属性
	RET = IN_TAG.find('i', attrs={'class':'icon-attr-water'})
	FLG = PD_CHECK_RET(RET)
	#RES_STR = PD_MAKE_STR('水', FLG)
	#ATTR_ARR.append(RES_STR)
	ATTR_ARR.append(FLG)
	#print(RET)
	#木属性
	RET = IN_TAG.find('i', attrs={'class':'icon-attr-wood'})
	FLG = PD_CHECK_RET(RET)
	#RES_STR = PD_MAKE_STR('木', FLG)
	#ATTR_ARR.append(RES_STR)
	ATTR_ARR.append(FLG)
	#print(RET)
	#光属性
	RET = IN_TAG.find('i', attrs={'class':'icon-attr-light'})
	FLG = PD_CHECK_RET(RET)
	#RES_STR = PD_MAKE_STR('光', FLG)
	#ATTR_ARR.append(RES_STR)
	ATTR_ARR.append(FLG)
	#print(RET)
	#闇属性
	RET = IN_TAG.find('i', attrs={'class':'icon-attr-dark'})
	FLG = PD_CHECK_RET(RET)
	#RES_STR = PD_MAKE_STR('闇', FLG)
	#ATTR_ARR.append(RES_STR)
	ATTR_ARR.append(FLG)
	#print(RET)
	return ATTR_ARR

#モンスターの属性を取得する
def PD_GET_ATTRIBUTE(IN_TAG):
	PD_ATTR = PD_CHECK_ATTRIBUTE(IN_TAG)
	#PD_TBL = ttb.Texttable()
	#PD_TBL = module04.MAKE_MATRIX(PD_ATTR, 5 + 1, 2)
	#PD_TBL.set_cols_align(["c", "c"])
	#print(PD_TBL.draw())
	#return(PD_TBL)
	return(PD_ATTR)

def main(NUMBER):
    pass
    PD_HTTP = module03.SET_PDNUM(NUMBER)
    PD_URL = module01.GET_URL_DATA(PD_HTTP)
    TEST_ARR = PD_GET_ATTRIBUTE(PD_URL)
    print(TEST_ARR)
    #for item in TEST_ARR:
    #	print(item)

if __name__=="__main__":
    main(PD_NUMBER)
