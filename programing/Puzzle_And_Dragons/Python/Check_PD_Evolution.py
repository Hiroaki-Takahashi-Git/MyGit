#coding:	cp932
from bs4 import BeautifulSoup
from urllib import request
from graphviz import Digraph
import sys
import types
import os
import numpy
import re
import requests
import codecs

#自作の関数
module01 = __import__('01_Get_URL')
module02 = __import__('Set_PD_Constant')

args = sys.argv
PROD_DIR = args[1]
PDNUMBER = args[2]

PD_ROOT = module02.PD_DB_URL
RESULT	= []

#モンスターのURLを設定
def pd_set_monster_url(PD_NUMBER):
	url_num = '%03d' % PD_NUMBER
	pd_url = PD_ROOT + '/m' + url_num
	#print(pd_url)
	return(pd_url)

#モンスターの全データを取得
def pd_get_all_data(IN_URL):
	CONTENT = IN_URL.find_all('div', attrs={'class', 'monster'})
	#print(CONTENT)
	return(CONTENT.prettify())

#モンスターの名前を取得
def pd_get_cur_evo_name(IN_URL):
	name_raw = IN_URL.find('h2', attrs={'class', 'title-bg mb-4'})
	name = re.sub(r'No\.[0-9]{1,4}\s', "", name_raw.get_text(strip=True))
	return(name)

#進化前のデータ部分を取得
def pd_get_bf_evo_data(IN_URL):
	tag = IN_URL.find('ul', attrs={'class', 'list-media-mim-full'})
	return(tag)
	
#進化素材を取得
def pd_get_evo_materials(IN_TAG):
	#print(IN_TAG)
	#tr_all = IN_TAG.find_all('table')
	table_all = IN_TAG.find_all('table', attrs={'class':'table mb-3'})
	# rows = len(table_all)
	#print(rows)
	evo_arr = []
	for table in table_all:
	#	print(table)
		pd_num = pd_get_number(table)
		pd_num = '%d' % int(pd_num)
		pd_name_raw = table.find('div', attrs={'class':'name'})
		pd_name_str = pd_name_raw.get_text(strip=True)
		#print(pd_name_str)
		mat_num_all = table.find_all('td', attrs={'class':'monsters'})
		#mat_num_all = table.find('td', attrs={'class':'monsters'})
		for mat_num in mat_num_all:
			#print(mat_num)
			mat_tag_all = mat_num.find_all('a')
			for mat_tag in mat_tag_all:
				mat_number = mat_tag['href']
				mat_number = re.sub(r'/m', "", mat_number)
				#mat_number = pd_get_number(mat_tag)
				#print(mat_number)
				mat_http = pd_set_monster_url(int(mat_number))
				mat_url = module01.GET_URL_DATA(mat_http)
				mat_name = pd_get_cur_evo_name(mat_url)
				#print('\t', mat_name)
				linedata = mat_number + ' ' + mat_name + ' ' + str(pd_num) + ' ' + pd_name_str
				#print(linedata)
				evo_arr.append(linedata)
	return(evo_arr)

#進化後のデータ部分を取得
def pd_get_af_evo_data(IN_URL):
	tag_all = IN_URL.find_all('td', attrs={'class', 'monster'})
	return(tag_all)

#進化前/後のモンスターの番号
def pd_get_number(IN_TAG):
	pd_num = IN_TAG.find('a')
	pd_num = pd_num['href']
	pd_num = re.sub(r'/m', "", pd_num)
	return(pd_num)
	
#進化後のモンスター名の取得
def pd_get_name(IN_TAG):
	name = IN_TAG.find('div', attrs={'class', 'name'})
	return(name.get_text(strip=True))

#ドットファイル(*.dot)の作成
def mk_evo_dot(IN_NUM, IN_ARR):
	if os.path.isdir(PROD_DIR) != True:
		os.mkdir(PROD_DIR)
	#出力先のファイル名を設定
	G = Digraph(format='png')
	#フォント指定
	G.attr('node', fontname="MS Gothic")
	fname = 'PDMonster%06d' % int(IN_NUM)
	png_fname = PROD_DIR + '\\' + fname
	# dot_fname = PROD_DIR + '\\' + fname + '.dot'
	#指定したモンスターの進化の情報
	#進化前後
	#進化素材
	arr_size = len(IN_ARR)
	#作成した行データ毎にメインのモンスターと進化素材を切り分ける
	# (進化前モンスター番号_進化前モンスター名_進化素材番号_進化素材名_進化後モンスター番号_進化後モンスター名)
	# (進化前モンスター番号?進化前モンスター名_進化後モンスター番号?進化後モンスター名)
	com_arr = []
	evo_arr = []
	for i in range(0, arr_size):
		data = IN_ARR[i].split(" ")
		if len(data) == 4:
			# print(IN_ARR[i])
			#進化の本線部分の設定
			#進化前のモンスター番号とモンスター名
			bf_num = data[0]
			bf_name = data[1]
			#進化後のモンスター番号とモンスター名
			af_num = data[2]
			af_name = data[3]
			bf_str = '{0}_{1}'.format(bf_num, bf_name)
			af_str = '{0}_{1}'.format(af_num, af_name)
			evo_str = '{0}_{1}'.format(bf_name, af_name)
			com_arr.append(bf_str)
			com_arr.append(af_str)
			evo_arr.append(evo_str)
	# #配列の重複を削除
	com_uniq_arr = list(set(com_arr))
	evo_uniq_arr = list(set(evo_arr))
	for i2 in range(0, len(com_uniq_arr)):
		linedata1 = com_uniq_arr[i2].split("_")
		if int(linedata1[0]) == int(IN_NUM):
			# print(linedata1[0])
			G.node(linedata1[1], shape="doublecircle", color="red")
		else:
			G.node(linedata1[1], shape="box")
	for i3 in range(0, len(evo_uniq_arr)):
		linedata2 = evo_uniq_arr[i3].split("_")		
		G.edge(linedata2[0], linedata2[1])
	print(G)
	#png形式で保存
	G.render(png_fname)
	# f = codecs.open(dot_fname, "w", "cp932", "ignore")
	# f.write(G)
	# f.close()

#クラス図の作成
def mk_evo_uml(IN_NUM, IN_ARR):
	if os.path.isdir(PROD_DIR) != True:
		os.mkdir(PROD_DIR)
	# pd_id = '%06d' % int(IN_NUM)
	fname = 'PDMonster%06d.pu' % int(IN_NUM)
	dat_fname = PROD_DIR + '\\' + fname
	#f = codecs.open(dat_fname, "w", "cp932", "ignore")
	f = codecs.open(dat_fname, "w", "utf8", "ignore")
	header = '@startuml' + '\t' + 'Number : ' + IN_NUM + '\n'
	f.write(header)
	arr_size = len(IN_ARR)
	obj_arr = []
	com_arr = []
	for j in range(0, arr_size):
		data = RESULT[j].split(" ")
		if len(data) == 4:
			bf_num = str('%06d' % int(data[0]))
			bf_obj = data[1]
			af_num = str('%06d' % int(data[2]))
			af_obj = data[3]
			bf_obj_str = "\tobject \"" + bf_obj + "\" as OBJID_" + bf_num + "\n"
			#print(bf_obj_str)
			af_obj_str = "\tobject \"" + af_obj + "\" as OBJID_" + af_num + "\n"
			#print(af_obj_str)
			obj_arr.append(bf_obj_str)
			obj_arr.append(af_obj_str)
			com_str = "\tOBJID_" + bf_num + " --|> OBJID_" + af_num + "\n"
			com_arr.append(com_str)
			#print(com_str)
		else:
			bf_num = str('%06d' % int(data[0]))
			bf_obj = data[1]
			mat_num = str('%06d' % int(data[2]))
			mat_obj = data[3]
			af_num = str('%06d' % int(data[4]))
			af_obj = data[5]
			mat_obj_str = "\tobject \"" + mat_obj + "\" as OBJID_" + mat_num + "\n"
			obj_arr.append(mat_obj_str)
			com_str = "\tOBJID_" + mat_num + " --* OBJID_" + af_num + "\n"
			com_arr.append(com_str)
	f.write("\n\t'オブジェクトの設定\n")
	com_uniq_arr = list(set(com_arr))
	obj_uniq_arr = list(set(obj_arr))
	#print(obj_uniq_arr)
	for k in range(0, len(obj_uniq_arr)):
		f.write(obj_uniq_arr[k])
	f.write("\n\t'進化の系統\n")
	for l in range(0, len(com_uniq_arr)):
		f.write(com_uniq_arr[l])
	f.write("\n@enduml\n")
	f.close()
	
def CHECK_PD_BF_EVOLUTION(PD_NUM):
	pass
	#PD_NUMBER = '%03d' % PD_NUM
	#IN_HTTP = PD_ROOT + '/m' + PD_NUMBER
	IN_HTTP = pd_set_monster_url(PD_NUM)
	PD_URL = module01.GET_URL_DATA(IN_HTTP)
	if PD_URL == "NODATA":
		pass
	else:
		line_arr = []
		PD_CUR_NAME = pd_get_cur_evo_name(PD_URL)
		print("進化後のモンスター：", PD_CUR_NAME)
		TAG = pd_get_bf_evo_data(PD_URL)
		#print(TAG)
		if TAG is None:
			print("進化前のモンスターはありません。")
			af_main(PD_NUM)
			line_arr.append("START")
		else:
			# bf_evo_list = []
			PD_BF_NUM = '%d' % int(pd_get_number(TAG))
			#print(PD_BF_NUM)
			PD_BF_NAME = pd_get_name(TAG)
			linedata = str(PD_BF_NUM) + ' ' + PD_BF_NAME + ' ' + str(PD_NUM) + ' ' + PD_CUR_NAME
			#print(linedata)
			line_arr.append(linedata)
		return(line_arr)

def CHECK_PD_AF_EVOLUTION(PD_NUM):
    pass
    IN_HTTP = pd_set_monster_url(PD_NUM)
    PD_URL = module01.GET_URL_DATA(IN_HTTP)
    
    if PD_URL == "NODATA":
    	pass
    	print("まだデータが存在していません。")
    else:
    	PD_CUR_NAME = pd_get_cur_evo_name(PD_URL)
    	print("進化前のモンスター：", PD_CUR_NAME)
    	#進化素材の入手
    	EVO_ARRAY = pd_get_evo_materials(PD_URL)
    	TAG_ALL = pd_get_af_evo_data(PD_URL)
    	ALL_SIZE = len(TAG_ALL)
    	line_arr = []
    	if (ALL_SIZE == 0):
    		print("これ以上の進化はありません。")
    		line_arr.append("END")
    	else:
    		af_evo_list = []
    		for ELEM in EVO_ARRAY:
    			#print("ELEM = ", ELEM)
    			linedata = str(PD_NUM) + ' ' + PD_CUR_NAME + ' ' + ELEM
    			line_arr.append(linedata)
    		for TAG in TAG_ALL:
    			PD_AF_NUM = '%d' % int(pd_get_number(TAG))
    			PD_AF_NAME = pd_get_name(TAG)
    			af_evo_list.append(PD_AF_NUM)
    			af_evo_list.append(PD_AF_NAME)
    			linedata = str(PD_NUM) + ' ' + PD_CUR_NAME + ' ' + str(PD_AF_NUM) + ' ' + PD_AF_NAME
    			#print(linedata)
    			line_arr.append(linedata)
    		#mk_evo_uml(PD_NUM, PD_CUR_NAME, af_evo_list)
    	return(line_arr)

#テスト部分
def PD_TEST(PD_NUMBER):
	test_url = pd_set_monster_url(PD_NUMBER)
	test_tag = module01.GET_URL_DATA(test_url)
	pd_get_evo_materials(test_tag)
	
def bf_main(PD_NUM):
	BF_SUBARR = []
	BF_SUBARR = CHECK_PD_BF_EVOLUTION(PD_NUM)
	if BF_SUBARR[0] != "START":
		arr_sz = len(BF_SUBARR)
		for i in range(0, arr_sz):
			#print(AF_SUBARR[i])
			#行データの分割
			RESULT.append(BF_SUBARR[i])
			data = BF_SUBARR[i].split(" ")
			#print(data)
			prev_num = int('%d' % int(data[0]))
			#print(next_num)
			bf_main(prev_num)
			#main(prev_num)

def af_main(PD_NUM):
	AF_SUBARR = []
	AF_SUBARR = CHECK_PD_AF_EVOLUTION(PD_NUM)
	if AF_SUBARR[0] != "END":
		arr_sz = len(AF_SUBARR)
		for i in range(0, arr_sz):
			#print(AF_SUBARR[i])
			#行データの分割
			RESULT.append(AF_SUBARR[i])
			data = AF_SUBARR[i].split(" ")
			#print(data)
			if len(data) == 4:
				next_num = int('%d' % int(data[2]))
			#next_num = int('%d' % int(data[4]))
			#print(next_num)
				af_main(next_num)
			#main(next_num)

def main(PD_NUM):
	#PD_TEST(PD_NUM)
	bf_main(PD_NUM)
	af_main(PD_NUM)

if __name__=="__main__":
    main(int(PDNUMBER))

#SET_RESULT = list(set(RESULT))
for k in range(0, len(RESULT)):
	print(RESULT[k])

# mk_evo_uml(PDNUMBER, RESULT)
mk_evo_dot(PDNUMBER, list(set(RESULT)))