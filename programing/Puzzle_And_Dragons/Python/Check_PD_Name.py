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

#モンスターの名前を取得する
def PD_GET_NAME(IN_TAG):
	NAME_TAG = IN_TAG.find('h2', attrs={'class', 'title-bg mb-4'})
	NAME_STR = NAME_TAG.get_text(strip=True)
	NAME_STR = re.sub('No\.[0-9]+\s', "", NAME_STR)
	return(NAME_STR)

def main(NUMBER):
    pass
    PD_HTTP = module03.SET_PDNUM(NUMBER)
    PD_URL = module01.GET_URL_DATA(PD_HTTP)
    TEST_NAME = PD_GET_NAME(PD_URL)
    #TEST_ARR = PD_GET_NAME(PD_URL)
    print(TEST_NAME)
    #for item in TEST_ARR:
    #	print(item)

if __name__=="__main__":
    main(PD_NUMBER)
