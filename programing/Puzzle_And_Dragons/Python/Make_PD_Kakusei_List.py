# coding: cp932
from bs4 import BeautifulSoup
from urllib import request
import sys
import re
import types
import requests
import codecs
import texttable as ttb

# 自作モジュール
MODULE01 = __import__('01_Get_URL')
CONSTANT = __import__('Set_PD_Constant')
#MODULE03 = __import__('Set_PD_Number')
#MODULE04 = __import__('03_Make_2DMatrix')
#PDM_NAME = __import__('Check_PD_Name')
#PDM_PAR1 = __import__('Check_PD_Rare_And_Cost_And_Assist')
#PDM_TYPE = __import__('Check_PD_Type')
#PDM_STATUS = __import__('Check_PD_Status')
#PDM_SKILL = __import__('Check_PD_Skill')
#PDM_AWAKE = __import__('Check_PD_Awakening')
#PDM_ATTR = __import__('Check_PD_Attribute')
#PDM_IMAGE = __import__('Check_PD_Image')

#args = sys.argv

def MAKE_AWAKING_LIST(IN_TAG):
	DIV_ALL = IN_TAG.find_all('DIV', attrs={'class':'name'})
	for DIV in DIV_ALL:
		print(DIV)

def main():
	pass
	#処理０１．URLの取得
	#print(CONSTANT.PD_DB_URL)
	HTTP = CONSTANT.PD_DB_URL + '/' + 'kakusei' + '/' + 'list'
	print(HTTP)
	URL = MODULE01.GET_URL_DATA(HTTP)
	#print(URL)
	if URL is not "NODATA":
		print(URL)
		MAKE_AWAKING_LIST(URL)
	else:
		sys.exit()

if __name__ == "__main__":
	main()