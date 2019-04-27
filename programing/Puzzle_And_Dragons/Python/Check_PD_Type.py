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

#自作の関数
module01 = __import__('01_Get_URL')
module02 = __import__('Set_PD_Constant')
module03 = __import__('Set_PD_Number')

#コマンドライン引数
args = sys.argv
PD_NUMBER	=	args[1]

#モンスターのタイプを取得する
def PD_GET_TYPES(IN_TAG):
	PD_TYPES = IN_TAG.find('p', attrs={'class', 'icon-mtype mb-3'})
	#print(PD_TYPES)
	TYPES_ALL = PD_TYPES.find_all('a')
	#print(TYPES_ALL)
	TYPE_ARR = []
	for TYPE in TYPES_ALL:
		TYPE_STR = TYPE.get_text(strip=True)
		TYPE_ARR.append(TYPE_STR)
	return(TYPE_ARR)

def main(NUMBER):
    pass
    PD_HTTP = module03.SET_PDNUM(NUMBER)
    PD_URL = module01.GET_URL_DATA(PD_HTTP)
    TEST_ARR = PD_GET_TYPES(PD_URL)
    #print(TEST_ARR)
    for item in TEST_ARR:
    	print(item)

if __name__=="__main__":
    main(PD_NUMBER)
