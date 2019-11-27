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
import time

#����̊֐�
module01 = __import__('01_Get_URL')
module02 = __import__('Set_PD_Constant')

args = sys.argv
PROD_DIR = args[1]
PDNUMBER = args[2]

PD_ROOT = module02.PD_DB_URL
RESULT	= []

#�����X�^�[��URL��ݒ�
def pd_set_monster_url(PD_NUMBER):
	url_num = '%03d' % PD_NUMBER
	pd_url = PD_ROOT + '/m' + url_num
	#print(pd_url)
	return(pd_url)

#�����X�^�[�̑S�f�[�^���擾
def pd_get_all_data(IN_URL):
	CONTENT = IN_URL.find_all('div', attrs={'class', 'monster'})
	#print(CONTENT)
	return(CONTENT.prettify())

#�����X�^�[�̖��O���擾
def pd_get_cur_evo_name(IN_URL):
	name_raw = IN_URL.find('h2', attrs={'class', 'title-bg mb-4'})
	name = re.sub(r'No\.[0-9]{1,4}\s', "", name_raw.get_text(strip=True))
	return(name)

#�i���O�̃f�[�^�������擾
def pd_get_bf_evo_data(IN_URL):
	tag = IN_URL.find('ul', attrs={'class', 'list-media-mim-full'})
	return(tag)
	
#�i���f�ނ��擾
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

#�i����̃f�[�^�������擾
def pd_get_af_evo_data(IN_URL):
	tag_all = IN_URL.find_all('td', attrs={'class', 'monster'})
	return(tag_all)

#�i���O/��̃����X�^�[�̔ԍ�
def pd_get_number(IN_TAG):
	pd_num = IN_TAG.find('a')
	pd_num = pd_num['href']
	pd_num = re.sub(r'/m', "", pd_num)
	return(pd_num)
	
#�i����̃����X�^�[���̎擾
def pd_get_name(IN_TAG):
	name = IN_TAG.find('div', attrs={'class', 'name'})
	return(name.get_text(strip=True))

#�h�b�g�t�@�C��(*.dot)�̍쐬
def mk_evo_dot(ROOT_DIR, IN_NUM, IN_ARR):
	if os.path.isdir(ROOT_DIR) != True:
		os.mkdir(ROOT_DIR)
	#�o�͐�̃t�@�C������ݒ�
	G = Digraph(format='png')
	#�t�H���g�w��
	G.attr('node', fontname="MS Gothic")
	fname = 'PDMonster%06d' % int(IN_NUM)
	png_fname = ROOT_DIR + '\\' + fname
	# dot_fname = ROOT_DIR + '\\' + fname + '.dot'
	#�w�肵�������X�^�[�̐i���̏��
	#�i���O��
	#�i���f��
	arr_size = len(IN_ARR)
	print('Array Size : {0}\n'.format(arr_size))
	#�쐬�����s�f�[�^���Ƀ��C���̃����X�^�[�Ɛi���f�ނ�؂蕪����
	# (�i���O�����X�^�[�ԍ�_�i���O�����X�^�[��_�i���f�ޔԍ�_�i���f�ޖ�_�i���ヂ���X�^�[�ԍ�_�i���ヂ���X�^�[��)
	# (�i���O�����X�^�[�ԍ�?�i���O�����X�^�[��_�i���ヂ���X�^�[�ԍ�?�i���ヂ���X�^�[��)
	com_arr = []
	evo_arr = []
	for i in range(0, arr_size):
		data = IN_ARR[i].split(" ")
		if len(data) == 4:
			# print(IN_ARR[i])
			#�i���̖{�������̐ݒ�
			#�i���O�̃����X�^�[�ԍ��ƃ����X�^�[��
			bf_num = data[0]
			bf_name = data[1]
			#�i����̃����X�^�[�ԍ��ƃ����X�^�[��
			af_num = data[2]
			af_name = data[3]
			#�i���O�̃����X�^�[�̔ԍ��Ɩ��O
			#bf_str = '{0}_{1}'.format(bf_num, bf_name)
			#�i����̃����X�^�[�̔ԍ��Ɩ��O
			#af_str = '{0}_{1}'.format(af_num, af_name)
			bf_pd_node = mk_node_string(bf_num, bf_name)
			af_pd_node = mk_node_string(af_num, af_name)
			#�i���O��̃����X�^�[��
			evo_str = '{0}_{1}'.format(bf_pd_node, af_pd_node)
			com_arr.append(bf_pd_node)
			com_arr.append(af_pd_node)
			evo_arr.append(evo_str)
	# #�z��̏d�����폜
	com_uniq_arr = list(set(com_arr))
	evo_uniq_arr = list(set(evo_arr))
	for i2 in range(0, len(com_uniq_arr)):
		# linedata1 = com_uniq_arr[i2].split("_")
		# linedata1[1] = re.sub('�C', ' ', linedata1[1])
		# if int(linedata1[0]) == int(IN_NUM):
		com_uniq_arr[i2] = re.sub('�C', ' ', com_uniq_arr[i2])
		print('Name:{0}\n'.format(com_uniq_arr[i2]))
		pattern_str = 'No.%06d' % int(IN_NUM)
		if re.match(pattern_str, com_uniq_arr[i2]):
			# print(linedata1[0])
			# pd_node = mk_node_string(linedata1[0], linedata1[1])
			# G.node(linedata1[1], shape="doublecircle", color="red")
			G.node(com_uniq_arr[i2], shape="box", color="red")
		else:
			# G.node(linedata1[1], shape="box")
			G.node(com_uniq_arr[i2], shape="box")
	for i3 in range(0, len(evo_uniq_arr)):
		linedata2 = evo_uniq_arr[i3].split("_")
		linedata2[0] = re.sub('�C', ' ', linedata2[0])
		linedata2[1] = re.sub('�C', ' ', linedata2[1])
		# �i���O��̃����X�^�[�����������m�F����
		if linedata2[0] != linedata2[1]:	
			G.edge(linedata2[0], linedata2[1])
	print(G)
	#png�`���ŕۑ�
	G.render(png_fname)

def mk_node_string(in_num, in_name):
	in_num2 = '%06d' % int(in_num)
	output = '''No.{pd_num}
{pd_name}
'''.format(pd_num = in_num2, pd_name = in_name)
	return output
	
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
		print("�i����̃����X�^�[�F", PD_CUR_NAME)
		TAG = pd_get_bf_evo_data(PD_URL)
		#print(TAG)
		if TAG is None:
			print("�i���O�̃����X�^�[�͂���܂���B")
			af_main(PD_NUM)
			line_arr.append("START")
		else:
			# bf_evo_list = []
			PD_BF_NUM = '%d' % int(pd_get_number(TAG))
			#print(PD_BF_NUM)
			PD_BF_NAME = pd_get_name(TAG)
			#���O���̋󔒕�����ʂ̕����ɒu��
			PD_BF_NAME = re.sub(' ', '�C', PD_BF_NAME)
			PD_CUR_NAME = re.sub(' ', '�C', PD_CUR_NAME)
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
    	print("�܂��f�[�^�����݂��Ă��܂���B")
    else:
    	PD_CUR_NAME = pd_get_cur_evo_name(PD_URL)
    	print("�i���O�̃����X�^�[�F", PD_CUR_NAME)
    	#�i���f�ނ̓���
    	EVO_ARRAY = pd_get_evo_materials(PD_URL)
    	TAG_ALL = pd_get_af_evo_data(PD_URL)
    	ALL_SIZE = len(TAG_ALL)
    	line_arr = []
    	if (ALL_SIZE == 0):
    		print("����ȏ�̐i���͂���܂���B")
    		line_arr.append("END")
    	else:
    		af_evo_list = []
    		for ELEM in EVO_ARRAY:
    			#print("ELEM = ", ELEM)
    			PD_CUR_NAME = re.sub(' ', '�C', PD_CUR_NAME)
    			linedata = str(PD_NUM) + ' ' + PD_CUR_NAME + ' ' + ELEM
    			line_arr.append(linedata)
    		for TAG in TAG_ALL:
    			PD_AF_NUM = '%d' % int(pd_get_number(TAG))
    			PD_AF_NAME = pd_get_name(TAG)
    			af_evo_list.append(PD_AF_NUM)
    			af_evo_list.append(PD_AF_NAME)
				#���O���̋󔒕�����ʂ̕����ɒu��
    			PD_CUR_NAME = re.sub(' ', '�C', PD_CUR_NAME)
    			PD_AF_NAME = re.sub(' ', '�C', PD_AF_NAME)
    			linedata = str(PD_NUM) + ' ' + PD_CUR_NAME + ' ' + str(PD_AF_NUM) + ' ' + PD_AF_NAME
    			#print(linedata)
    			line_arr.append(linedata)
    		#mk_evo_uml(PD_NUM, PD_CUR_NAME, af_evo_list)
    	return(line_arr)

#�e�X�g����
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
			#�s�f�[�^�̕���
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
			#�s�f�[�^�̕���
			RESULT.append(AF_SUBARR[i])
			data = AF_SUBARR[i].split(" ")
			#print(data)
			if len(data) == 4:
				next_num = int('%d' % int(data[2]))
			#next_num = int('%d' % int(data[4]))
			#print(next_num)
				af_main(next_num)
			#main(next_num)

def main(PD_PRODDIR, PD_NUM):
	#PD_TEST(PD_NUM)
	start1 = time.time()
	bf_main(PD_NUM)
	bf_time = time.time() - start1
	start2 = time.time()
	af_main(PD_NUM)
	af_time = time.time() - start2
	mk_evo_dot(PD_PRODDIR, PD_NUM, list(set(RESULT)))
	print("PD Number : {0}".format(int(PD_NUM)))
	print("Elapsed Time (Before): {0}".format('%.3lf' % bf_time) + "[sec]")
	print("Elapsed Time (After ): {0}".format('%.3lf' % af_time) + "[sec]")
	print("\n")
	RESULT.clear()
	# print('TEST\n')

if __name__=="__main__":
    main(PROD_DIR, int(PDNUMBER))

#SET_RESULT = list(set(RESULT))
for k in range(0, len(RESULT)):
	print(RESULT[k])

# RESULT = []
# mk_evo_uml(PDNUMBER, RESULT)
# mk_evo_dot(PDNUMBER, list(set(RESULT)))
