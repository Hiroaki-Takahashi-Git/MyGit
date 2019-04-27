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
import collections

#自作の関数
module01 = __import__('01_Get_URL')
module02 = __import__('Set_PD_Constant')
module03 = __import__('Set_PD_Number')

#コマンドライン引数
args = sys.argv
PD_NUMBER	=	args[1]

#モンスターのスキルを取得する
def PD_GET_AWAKEING_1(IN_TAG):
	DIV_ALL = IN_TAG.find_all('div', attrs={'class', 'spacer mb-5'})
	
	AWAKENING_ARR = []
	for DIV_TAG in DIV_ALL:
		#スキル名のタグ
		HEADER_TAG = DIV_TAG.find('h3', attrs={'class', 'title-border'})
		#print(HEADER_TAG)
		if HEADER_TAG is not None:
			HEADER_STR = HEADER_TAG.get_text(strip=True)
			#print(HEADER_STR)
			if re.match('覚醒スキル', HEADER_STR) is not None:
				#AWAKENING_NAME_TAG = DIV_TAG.find('p', attrs={'class', 'mb-2'})
				#print(AWAKENING_NAME_TAG)
				AWAKENING_CAT_TAG = DIV_TAG.find_all('ul', attrs={'class', 'list-kakusei-skill-desc mb-3'})
				#print(AWAKENING_CAT_TAG)
				if AWAKENING_CAT_TAG is not None:
					for AWAKENING_TAG in AWAKENING_CAT_TAG:
				#		print(AWAKENING_TAG)
				#		print('\n')
						AWAKENING_DATA = AWAKENING_TAG.find_all('div', attrs={'class', 'name'})
				#		print(AWAKENING_DATA)
				#		if AWAKENING_DATA is not None:
				#			print(AWAKENING_DATA)
						for AWAKENING in AWAKENING_DATA:
				#			print(AWAKENING)
							AWAKENING_NAME = AWAKENING.get_text(strip=True)
				#			print(AWAKENING_NAME)
							AWAKENING_ARR.append(AWAKENING_NAME)
	#print(AWAKENING_ARR)
	#c = collections.Counter(AWAKENING_ARR)
	#print(c)
	return(collections.Counter(AWAKENING_ARR))
	#RESP_ARR = []
	#for KEY in c.keys():
	#	#print(KEY)
	#	VALUE = c[KEY]
	#	#print(VALUE)
	#	RESP_ARR.append(KEY)
	#	RESP_ARR.append(VALUE)
	#return RESP_ARR, len(c.items())

def PD_GET_AWAKEING_2(IN_TAG):
	DIV_ALL = IN_TAG.find_all('div', attrs={'class', 'spacer mb-5'})
	
	AWAKENING_ARR = []
	for DIV_TAG in DIV_ALL:
		HEADER_TAG = DIV_TAG.find('h3', attrs={'class', 'title-border'})
		if HEADER_TAG is not None:
			HEADER_STR = HEADER_TAG.get_text(strip=True)
			if re.match('超覚醒スキル', HEADER_STR) is not None:
				#AWAKENING_NAME_TAG = DIV_TAG.find('p', attrs={'class', 'mb-2'})
				AWAKENING_CAT_TAG = DIV_TAG.find_all('ul', attrs={'class', 'list-kakusei-skill-desc mb-3'})
				if AWAKENING_CAT_TAG is not None:
					for AWAKENING_TAG in AWAKENING_CAT_TAG:
						AWAKENING_DATA = AWAKENING_TAG.find_all('div', attrs={'class', 'name'})
						for AWAKENING in AWAKENING_DATA:
							AWAKENING_NAME = AWAKENING.get_text(strip=True)
							AWAKENING_ARR.append(AWAKENING_NAME)
	return(collections.Counter(AWAKENING_ARR))

def PD_GET_AWAKEING_3(IN_TAG):
	DIV_ALL = IN_TAG.find_all('div', attrs={'class', 'spacer mb-5'})
	
	AWAKENING_ARR = []
	for DIV_TAG in DIV_ALL:
		HEADER_TAG = DIV_TAG.find('h3', attrs={'class', 'title-border'})
		if HEADER_TAG is not None:
			HEADER_STR = HEADER_TAG.get_text(strip=True)
			if re.match('付けられる潜在キラー', HEADER_STR) is not None:
				#AWAKENING_NAME_TAG = DIV_TAG.find('p', attrs={'class', 'mb-2'})
				AWAKENING_CAT_TAG = DIV_TAG.find_all('ul', attrs={'class', 'list-kakusei-skill-desc mb-3'})
				if AWAKENING_CAT_TAG is not None:
					for AWAKENING_TAG in AWAKENING_CAT_TAG:
						AWAKENING_DATA = AWAKENING_TAG.find_all('div', attrs={'class', 'name'})
						for AWAKENING in AWAKENING_DATA:
							AWAKENING_NAME = AWAKENING.get_text(strip=True)
							AWAKENING_ARR.append(AWAKENING_NAME)
	return(collections.Counter(AWAKENING_ARR))

def main(NUMBER):
    pass
    PD_HTTP = module03.SET_PDNUM(NUMBER)
    PD_URL = module01.GET_URL_DATA(PD_HTTP)
    TEST_ARR1 = PD_GET_AWAKEING_1(PD_URL)
    TEST_ARR2 = PD_GET_AWAKEING_2(PD_URL)
    TEST_ARR3 = PD_GET_AWAKEING_3(PD_URL)
    #print(TEST_ARR)
    #for key in TEST_ARR.keys():
    #	print(key)
    #	print(TEST_ARR[key])
    for item in TEST_ARR1.items():
    	print(item)
    print('\n')
    for item in TEST_ARR2.items():
    	print(item)
    print('\n')
    for item in TEST_ARR3.items():
    	print(item)

if __name__=="__main__":
    main(PD_NUMBER)
