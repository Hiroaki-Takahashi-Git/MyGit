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

#����̊֐�
module01 = __import__('01_Get_URL')
module02 = __import__('Set_PD_Constant')
module03 = __import__('Set_PD_Number')
module04 = __import__('03_Make_2DMatrix')

#�R�}���h���C������
args = sys.argv
PD_NUMBER	=	args[1]

#�����̗L��
def PD_CHECK_RET(RET):
	if RET is not None:
		return '�Z'
	else:
		return '�~'

#�����̗L���̕�����
def PD_MAKE_STR(ATTR, RET):
	RES_STR = ATTR + '�|��' + RET
	#print(RES_STR)
	return(RES_STR)
	
#�����X�^�[�̑������m�F����
def PD_CHECK_ATTRIBUTE(IN_TAG):
	ATTR_ARR = []
	#ATTR_COL = ["���@��", "�Z�^�~"]
	#ATTR_ARR.extend(ATTR_COL)
	#�Α���
	RET = IN_TAG.find('i', attrs={'class':'icon-attr-fire'})
	FLG = PD_CHECK_RET(RET)
	#RES_STR = PD_MAKE_STR('��', FLG)
	#ATTR_ARR.append(RES_STR)
	ATTR_ARR.append(FLG)
	#print(RET)
	#������
	RET = IN_TAG.find('i', attrs={'class':'icon-attr-water'})
	FLG = PD_CHECK_RET(RET)
	#RES_STR = PD_MAKE_STR('��', FLG)
	#ATTR_ARR.append(RES_STR)
	ATTR_ARR.append(FLG)
	#print(RET)
	#�ؑ���
	RET = IN_TAG.find('i', attrs={'class':'icon-attr-wood'})
	FLG = PD_CHECK_RET(RET)
	#RES_STR = PD_MAKE_STR('��', FLG)
	#ATTR_ARR.append(RES_STR)
	ATTR_ARR.append(FLG)
	#print(RET)
	#������
	RET = IN_TAG.find('i', attrs={'class':'icon-attr-light'})
	FLG = PD_CHECK_RET(RET)
	#RES_STR = PD_MAKE_STR('��', FLG)
	#ATTR_ARR.append(RES_STR)
	ATTR_ARR.append(FLG)
	#print(RET)
	#�ő���
	RET = IN_TAG.find('i', attrs={'class':'icon-attr-dark'})
	FLG = PD_CHECK_RET(RET)
	#RES_STR = PD_MAKE_STR('��', FLG)
	#ATTR_ARR.append(RES_STR)
	ATTR_ARR.append(FLG)
	#print(RET)
	return ATTR_ARR

#�����X�^�[�̑������擾����
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
