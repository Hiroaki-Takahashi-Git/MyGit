# coding: cp932
import codecs
import re
import sys
import types
from urllib import request

import requests
import texttable as ttb
from bs4 import BeautifulSoup
import cv2
import collections as cl
import json

# 自作モジュール
MODULE01 = __import__('01_Get_URL')
MODULE02 = __import__('Set_PD_Constant')
MODULE03 = __import__('Set_PD_Number')
MODULE04 = __import__('03_Make_2DMatrix')
PDM_NAME = __import__('Check_PD_Name')
PDM_PAR1 = __import__('Check_PD_Rare_And_Cost_And_Assist')
PDM_TYPE = __import__('Check_PD_Type')
PDM_STATUS = __import__('Check_PD_Status')
PDM_SKILL = __import__('Check_PD_Skill')
PDM_AWAKE = __import__('Check_PD_Awakening')
PDM_ATTR = __import__('Check_PD_Attribute')
PDM_IMAGE = __import__('Check_PD_Image')

args = sys.argv
PD_NUMBER	=	args[1]
PD_FILENAME	=	args[2]

def writeData(FNAME, TBL_ARR):
	f = codecs.open(FNAME, "w", "cp932", "ignore")
	for TBL in TBL_ARR:
		f.write(TBL.draw() + "\n")
		f.write("")
	f.close()

def main(NUMBER, FNAME):
	pass
	TBL_ARR = []
	PD_DATA_CL = cl.OrderedDict()

	# print('Number = %03d' % NUMBER + "\n")
	NUM_COL = ["Number"]
	NUM_ARR = [NUMBER]
	NUM_TBL = ttb.Texttable()
	NUM_TBL = MODULE04.MAKE_MATRIX(NUM_COL, NUM_ARR)
	# print(NUM_TBL.draw())
	# print("")
	TBL_ARR.append(NUM_TBL)
	PD_DATA_CL["number"] = NUMBER
	# print(PD_DATA_CL["number"])

	#処理０１．URLの取得
	HTTP = MODULE03.SET_PDNUM(NUMBER)
	URL = MODULE01.GET_URL_DATA(HTTP)
	if URL is not "NODATA":

		#print("HTTP = " + HTTP + "\n")
		HTTP_COL = ["URL"]
		HTTP_ARR = [HTTP]
		HTTP_TBL = ttb.Texttable()
		HTTP_TBL = MODULE04.MAKE_MATRIX(HTTP_COL, HTTP_ARR)
		# print(HTTP_TBL.draw())
		# print("")
		TBL_ARR.append(HTTP_TBL)
		PD_DATA_CL["url"] = HTTP
		
		#処理０２．モンスターの名前
		NAME = PDM_NAME.PD_GET_NAME(URL)
		NAME_COL = ["Name"]
		NAME_ARR = [NAME]
		NAME_TBL = ttb.Texttable()
		NAME_TBL = MODULE04.MAKE_MATRIX(NAME_COL, NAME_ARR)
		# print(NAME_TBL.draw())
		# print("")
		TBL_ARR.append(NAME_TBL)
		PD_DATA_CL["name"] = NAME
		
		#処理０３．レア度・コスト
		RARE, COST, ASSIST = PDM_PAR1.PD_GET_RARE_COST_ASSISTANT(URL)
		ETC_COL = ["RARE", "COST", "ASSIST"]
		ETC_ARR = [RARE, COST, ASSIST]
		ETC_TBL = ttb.Texttable()
		ETC_TBL = MODULE04.MAKE_MATRIX(ETC_COL, ETC_ARR)
		# print(ETC_TBL.draw())
		# print("")
		TBL_ARR.append(ETC_TBL)
		PD_DATA_CL["rare"] = RARE
		PD_DATA_CL["cost"] = int(COST)
		if ASSIST == '〇':
			PD_DATA_CL["assistance"] = bool(ASSIST == '〇')
		else:
			PD_DATA_CL["assistance"] = False
		# print(PD_DATA_CL["assistance"])

		#処理０４．モンスター属性
		ATTR_COL = ["火", "水", "木", "光", "闇"]
		ATTR_ARR = PDM_ATTR.PD_GET_ATTRIBUTE(URL)
		ATTR_TBL = ttb.Texttable()
		ATTR_TBL = MODULE04.MAKE_MATRIX(ATTR_COL, ATTR_ARR)
		# print(ATTR_TBL.draw())
		# print("")
		TBL_ARR.append(ATTR_TBL)
		ATTR_DATA = cl.OrderedDict()
		for i in range(0, len(ATTR_COL)):
			ATTR = ATTR_ARR[i]
			ATTR_DATA[ATTR_COL[i]] = bool(ATTR == '〇')
		PD_DATA_CL["attribute"] = ATTR_DATA

		#処理０５．モンスタータイプ
		TYPE_ARR = PDM_TYPE.PD_GET_TYPES(URL)
		CNT1 = 1
		TYPE_COL = []
		while CNT1 <= len(TYPE_ARR):
			TYPE_STR = "TYPE" + str(CNT1)
			TYPE_COL.append(TYPE_STR)
			CNT1 = CNT1 + 1
		TYPE_TBL = ttb.Texttable()
		TYPE_TBL = MODULE04.MAKE_MATRIX(TYPE_COL, TYPE_ARR)
		# print(TYPE_TBL.draw())
		# print("")
		TBL_ARR.append(TYPE_TBL)
		TYPE_ALL = [
			"ドラゴンタイプ",
			"体力タイプ",
			"攻撃タイプ",
			"回復タイプ",
			"バランスタイプ",
			"神タイプ",
			"強化合成用モンスター",
			"進化用モンスター",
			"悪魔タイプ",
			"覚醒用モンスター",
			"マシンタイプ",
			"売却用モンスター"
		]
		TYPE_DATA = cl.OrderedDict()
		for i in range(0, len(TYPE_ALL)):
			TYPE = TYPE_ALL[i]
			TYPE_DATA[TYPE_ALL[i]] = bool(TYPE in TYPE_ARR)
		PD_DATA_CL["type"] = TYPE_DATA
		
		#処理０６．ステータス
		STAT_ARR, STAT_COL = PDM_STATUS.PD_GET_STATUS(URL)
		# print("STATUS =")
		COL_ARR = STAT_ARR[0:STAT_COL]
		DAT_ARR = STAT_ARR[STAT_COL:]
		STAT_TBL = ttb.Texttable()
		STAT_TBL = MODULE04.MAKE_MATRIX(COL_ARR, DAT_ARR)
		# print(STAT_TBL.draw())
		# print("")
		TBL_ARR.append(STAT_TBL)
		STAT_ROW = int(len(DAT_ARR) / STAT_COL)
		STAT_DATA = cl.OrderedDict()
		for j in range(1, STAT_ROW):
			SUB_STAT_ROW = cl.OrderedDict()
			IDX = STAT_COL * j
			# print(DAT_ARR[IDX])
			for i in range(1, STAT_COL):
				# print(COL_ARR[i])
				IDX2 = STAT_COL * j + i
				# print(DAT_ARR[IDX2])
				if DAT_ARR[IDX2] != "未確認":
					SUB_STAT_ROW[COL_ARR[i]] = int(DAT_ARR[IDX2].replace(',', ''))
				else:
					SUB_STAT_ROW[COL_ARR[i]] = DAT_ARR[IDX2]
			STAT_DATA[DAT_ARR[IDX]] = SUB_STAT_ROW
		PD_DATA_CL["parameters"] = STAT_DATA

		#処理０７．スキル、リーダースキル
		SKILL_ARR1 = PDM_SKILL.PD_GET_SKILL(URL)
		# print("スキル・リーダースキル =")
		SKILL_COL = ["", "名前", "タイプ", "内容"]
		SKILL_TBL = ttb.Texttable()
		SKILL_TBL = MODULE04.MAKE_MATRIX(SKILL_COL, SKILL_ARR1)
		# print(SKILL_TBL.draw())
		# print("")
		TBL_ARR.append(SKILL_TBL)
		SKILL_DATA = cl.OrderedDict()
		SKILL_ROW = int(len(SKILL_ARR1) / len(SKILL_COL))
		for j in range(0, SKILL_ROW):
			IDX1 = j * len(SKILL_COL)
			# print(SKILL_ARR1[IDX1])
			SUB_SKILL_DATA = cl.OrderedDict()
			for i in range(1, len(SKILL_COL)):
				IDX2 = j * len(SKILL_COL) + i
				if SKILL_COL[i] == "タイプ":
					SUB_ARR1 = SKILL_ARR1[IDX2].split('\n')
					# print(S)
					SUB_DICT = cl.OrderedDict()
					for k in range(0, len(SUB_ARR1)):
						IDX3 = 'type' + str(k + 1)
						SUB_DICT[IDX3] = SUB_ARR1[k]
					SUB_SKILL_DATA[SKILL_COL[i]] = SUB_DICT
				else:
					SUB_SKILL_DATA[SKILL_COL[i]] = SKILL_ARR1[IDX2].replace('。\n', '。')
			SKILL_DATA[SKILL_ARR1[IDX1]] = SUB_SKILL_DATA
		PD_DATA_CL["skills"] = SKILL_DATA
		
		#処理０８．覚醒スキル・超覚醒スキル・潜在キラー
		AWAKE_ARR1 = PDM_AWAKE.PD_GET_AWAKEING_1(URL)
		AWAKE_COL = ["覚醒タイプ", "個数"]
		if len(AWAKE_ARR1) > 0:
			# print("覚醒スキル =")
			AWAKE_ARR = []
			SUB_AWAKE_DICT1 = cl.OrderedDict()
			for AWAKE_NAME, AWAKE_NUM in AWAKE_ARR1.items():
				AWAKE_ARR.append(AWAKE_NAME)
				AWAKE_ARR.append(AWAKE_NUM)
				SUB_AWAKE_DICT1[AWAKE_NAME] = int(AWAKE_NUM)
			AWAKE_TBL1 = ttb.Texttable()
			AWAKE_TBL1 = MODULE04.MAKE_MATRIX(AWAKE_COL, AWAKE_ARR)
			# print(AWAKE_TBL1.draw())
			# print("")
			PD_DATA_CL["awake1"] = SUB_AWAKE_DICT1
			TBL_ARR.append(AWAKE_TBL1)
		SUPER_AWAKE_ARR = PDM_AWAKE.PD_GET_AWAKEING_2(URL)
		if len(SUPER_AWAKE_ARR) > 0:
			# print("超覚醒スキル =")
			AWAKE_ARR = []
			SUB_AWAKE_DICT2 = cl.OrderedDict()
			for SUPER_AWAKE_NAME, SUPER_AWAKE_NUM in SUPER_AWAKE_ARR.items():
				AWAKE_ARR.append(SUPER_AWAKE_NAME)
				AWAKE_ARR.append(SUPER_AWAKE_NUM)
				SUB_AWAKE_DICT2[SUPER_AWAKE_NAME] = int(SUPER_AWAKE_NUM)
			AWAKE_TBL2 = ttb.Texttable()
			AWAKE_TBL2 = MODULE04.MAKE_MATRIX(AWAKE_COL, AWAKE_ARR)
			# print(AWAKE_TBL2.draw())
			# print("")
			PD_DATA_CL["awake2"] = SUB_AWAKE_DICT2
			TBL_ARR.append(AWAKE_TBL2)
		SUPER_AWAKE_ARR = PDM_AWAKE.PD_GET_AWAKEING_2(URL)
		KILLER_ARR = PDM_AWAKE.PD_GET_AWAKEING_3(URL)
		if len(KILLER_ARR) > 0:
			# print("潜在キラー =")
			AWAKE_ARR = []
			SUB_AWAKE_DICT3 = cl.OrderedDict()
			for KILLER_NAME, KILLER_NUM in KILLER_ARR.items():
				AWAKE_ARR.append(KILLER_NAME)
				AWAKE_ARR.append(KILLER_NUM)
				SUB_AWAKE_DICT3[KILLER_NAME] = int(KILLER_NUM)
			AWAKE_TBL3 = ttb.Texttable()
			AWAKE_TBL3 = MODULE04.MAKE_MATRIX(AWAKE_COL, AWAKE_ARR)
			# print(AWAKE_TBL3.draw())
			PD_DATA_CL["killer"] = SUB_AWAKE_DICT3
			TBL_ARR.append(AWAKE_TBL3)
		
		#処理０９．モンスターの画像を取得する
		IMG_NAME = FNAME.replace('tsv', 'jpg')
		# print(IMG_NAME)
		IMG_PATH = PDM_IMAGE.PD_GET_IMAGE(URL)
		PD_DATA_CL["img_url"] = IMG_PATH
		REQ = request.urlopen(IMG_PATH)
		f = open(IMG_NAME, "wb")
		f.write(REQ.read())
		f.close()		

	else:
		ERROR_TBL = ttb.Texttable()
		ERROR_COL = ["URL"]
		ERROR_DAT = ["NODATA"]
		ERROR_TBL = MODULE04.MAKE_MATRIX(ERROR_COL, ERROR_DAT)
		TBL_ARR.append(ERROR_TBL)

	for TBL in TBL_ARR:
		print(TBL.draw())
		print("")
	
	writeData(FNAME, TBL_ARR)

	#処理１０．JSONファイルへの書き込み
	JSON_NAME = FNAME.replace('tsv', 'json')
	FW_JSON = codecs.open(JSON_NAME, 'w', 'utf-8')
	json.dump(PD_DATA_CL, FW_JSON, ensure_ascii=False, indent=4)
	FW_JSON.close()

if __name__ == "__main__":
	INT_NUM = int(PD_NUMBER)
	main(INT_NUM, PD_FILENAME)
