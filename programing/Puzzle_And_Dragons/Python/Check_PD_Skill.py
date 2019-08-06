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
import jaconv

#自作の関数
module01 = __import__('01_Get_URL')
module02 = __import__('Set_PD_Constant')
module03 = __import__('Set_PD_Number')

#コマンドライン引数
args = sys.argv
PD_NUMBER	=	args[1]

#モンスターのスキルを取得する
def PD_GET_SKILL(IN_TAG):
	DIV_ALL = IN_TAG.find_all('div', attrs={'class', 'spacer mb-5'})
	
	SKILL_ARR = []
	for DIV_TAG in DIV_ALL:
		#スキル名のタグ
		SKILL_TAG = DIV_TAG.find('h3', attrs={'class', 'title-border mb-3'})
		SKILL_NAME_TAG = DIV_TAG.find('p', attrs={'class', 'mb-2'})
		SKILL_CAT_TAG = DIV_TAG.find('ul', attrs={'class', 'list-round-rect mb-4 spacer'})
		#print(SKILL_CAT_TAG)
		if SKILL_CAT_TAG is None:
			#SKILL_ARR.append('NOSKILL')
			continue
		SKILL_TXT_TAG = DIV_TAG.find('p', attrs={'class', 'mb-3'})
		#print(SKILL_CAT_TAG)
		#スキル名の取得
		if SKILL_TAG is not None:
			SKILL_STR = SKILL_TAG.get_text(strip=True)
			#print(SKILL_STR)
			if re.match('スキル', SKILL_STR) is not None or \
				re.match('リーダースキル', SKILL_STR) is not None:
				#print('CHECK' + SKILL_STR)
				if re.match('スキル', SKILL_STR) is not None:
					PREFIX = 'スキル'
				else:
					PREFIX = 'リーダースキル'
				SKILL_ARR.append(PREFIX)
				#SKILL_ARR.append(SKILL_STR)
				SKILL_NAME = SKILL_NAME_TAG.find('strong')
				#print(SKILL_NAME)
				SKILL_STR = SKILL_NAME.get_text(strip=True)
				#print(SKILL_STR)
				SKILL_ARR.append(SKILL_STR)
				SKILL_CAT_ALL = SKILL_CAT_TAG.find_all('a')
				#print(SKILL_CAT_ALL)
				#print(type(SKILL_CAT_ALL))
				if SKILL_CAT_ALL is None:
					print("要素がありません。\n")
				CAT_ARR = []
				for SKILL_CAT in SKILL_CAT_ALL:
					SKILL_CAT_STR = SKILL_CAT.get_text(strip=True)
					#print(SKILL_CAT_STR)
					CAT_ARR.append(SKILL_CAT_STR)
				#CAT_LINEDATA = '\n'.join(CAT_ARR)
				CAT_LINEDATA = '\n'.join(CAT_ARR)
				#print(CAT_LINEDATA)
				SKILL_ARR.append(CAT_LINEDATA)
				SKILL_TEXT = SKILL_TXT_TAG.get_text(strip=True)
				#print(SKILL_TEXT)
				SKILL_TEXT = re.sub('。', '。\n', SKILL_TEXT)
				#SKILL_TEXT = re.sub('\s+|　', '', SKILL_TEXT)
				#print(SKILL_TEXT)
				#SKILL_TEXT2 = insert_str(SKILL_TEXT, 15)
				#print(test)
				SKILL_ARR.append(SKILL_TEXT)
				#SKILL_ARR.append(SKILL_TEXT2)
	print(SKILL_ARR)
	return(SKILL_ARR)

#テキスト文書に改行'\n'を挿入する
def insert_str(IN_STR, STR_NUM):
	#print(IN_STR)
	IN_STR_ARR = IN_STR.split('★')
	outstr_arr = []
	for ELEM_STR in IN_STR_ARR:
		if ELEM_STR == "":
			continue
		#print("ELEMENT : " + ELEM_STR)
		IN_STR2 = jaconv.h2z(ELEM_STR,digit=False,ascii=True)
		#print('INPUT : ' + IN_STR2)
		str_sz = len(IN_STR2)
		str_setnum = int(len(IN_STR2) / STR_NUM)
		#print(str_setnum)
		for j in range(0, str_setnum + 1):
			linedata = []
			for i in range(0, STR_NUM):
				idx = j * STR_NUM + i
				#print(idx)
				if idx >= str_sz:
					continue
				#print(IN_STR[idx])
				else:
					linedata.append(IN_STR2[idx])
			linedata2 = ''.join(linedata)
			outstr_arr.append(linedata2)
	outstr = '\n'.join(outstr_arr)
	#outstr = outstr.replace("。\n", "。")
	#print(outstr)
	return(outstr)

def main(NUMBER):
    pass
    PD_HTTP = module03.SET_PDNUM(NUMBER)
    PD_URL = module01.GET_URL_DATA(PD_HTTP)
    TEST_ARR = PD_GET_SKILL(PD_URL)
    #print(TEST_ARR)
    for item in TEST_ARR:
    	print(item)

if __name__=="__main__":
    main(PD_NUMBER)
