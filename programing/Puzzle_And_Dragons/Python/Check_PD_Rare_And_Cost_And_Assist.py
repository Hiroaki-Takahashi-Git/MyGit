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
def PD_GET_RARE_COST_ASSISTANT(IN_TAG):
	REG = re.compile(r"(\S+)\/(\S+)\/(\S+)")
	RARE_TAG = IN_TAG.find('p', attrs={'class', 'mb-2'})
	RARE_STR = RARE_TAG.get_text(strip=True)
	RARE_STR = re.sub('^\/|\s|コスト:|アシスト:', "", RARE_STR)
	M = REG.match(RARE_STR)
	return M.group(1), M.group(2), M.group(3)

def main(NUMBER):
    pass
    PD_HTTP = module03.SET_PDNUM(NUMBER)
    PD_URL = module01.GET_URL_DATA(PD_HTTP)
    TEST_RARE, TEST_COST, TEST_FLAG = PD_GET_RARE_COST_ASSISTANT(PD_URL)
    #TEST_ARR = PD_GET_RARE_COST_ASSISTANT(PD_URL)
    print(TEST_RARE)
    print(TEST_COST)
    print(TEST_FLAG)
    #for item in TEST_ARR:
    #	print(item)

if __name__=="__main__":
    main(PD_NUMBER)
