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

#�����̕�����ϊ�
def PD_CONVERT_ATTRIBUTE(IN_ATTR):
	# print(IN_ATTR)
	if IN_ATTR == "icon-attr-fire":
		# print(IN_ATTR)
		return('��')	
	if IN_ATTR == "icon-attr-water":
		# print(IN_ATTR)
		return('��')	
	if IN_ATTR == "icon-attr-wood":
		# print(IN_ATTR)
		return('��')	
	if IN_ATTR == "icon-attr-light":
		# print(IN_ATTR)
		return('��')	
	if IN_ATTR == "icon-attr-dark":
		# print(IN_ATTR)
		return('��')
	
#�����X�^�[�̑������m�F����
def PD_CHECK_ATTRIBUTE(IN_TAG):
	ATTR_DICT = {}

	#'icon-attr'���܂ޑS�Ă�class���������o
	ATTR_ALL = IN_TAG.find_all("i", class_=re.compile("icon-attr"))

	ATTR_IDX = 1
	for ATTR_ELEM in ATTR_ALL:
		LIST = ATTR_ELEM.get('class')
		# ATTR_STR = LIST[0]
		ATTR_STR = PD_CONVERT_ATTRIBUTE(LIST[0])
		ATTR_DICT[ATTR_STR] = ATTR_IDX
		ATTR_IDX += 1
	
	ATTR_DICT2 = {
		'��':'NODATA',
		'��':'NODATA',
	}

	DICT_SZ = len(ATTR_DICT)
	for ATTR_KEY in ATTR_DICT:
		ATTR_VAL = ATTR_DICT[ATTR_KEY]
		if 2 == DICT_SZ:
			if 1 == ATTR_VAL:
				ATTR_DICT2['��'] = ATTR_KEY
			else:
				ATTR_DICT2['��'] = ATTR_KEY
		else:
			ATTR_DICT2['��'] = ATTR_KEY
			if 2 == ATTR_VAL:
				ATTR_DICT2['��'] = ATTR_KEY

	return(ATTR_DICT2)

#�����X�^�[�̑������擾����
def PD_GET_ATTRIBUTE(IN_TAG):
	PD_ATTR = PD_CHECK_ATTRIBUTE(IN_TAG)
	return(PD_ATTR)

def main(NUMBER):
    pass
    PD_HTTP = module03.SET_PDNUM(NUMBER)
    PD_URL = module01.GET_URL_DATA(PD_HTTP)
    TEST_ARR = PD_GET_ATTRIBUTE(PD_URL)
    print(TEST_ARR)

if __name__=="__main__":
    main(PD_NUMBER)
