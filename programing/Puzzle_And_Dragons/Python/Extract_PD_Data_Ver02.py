# coding: cp932
from bs4 import BeautifulSoup
from urllib import request
import sys
import types
import os
import numpy
import re
import requests
import codecs

args = sys.argv
dat_dir = args[1]

# URL�̗L�����m�F����
def Check_url(http):
	try:
		resp = request.urlopen(http)
		resp.close()
		return "OK"
	except request.HTTPError:
		return "NG"

# �p�Y�h�������X�^�[�̃f�[�^���擾����
def Get_PDMonster_Inf(root_http, num, type_arr, kakusei_arr):
	pd_dat_unit = []
	pd_dat_unit.append(num)
	pd_num = '%03d' % num
	http = root_http + '/m' + pd_num
	ret = Check_url(http)
	if ret == "OK":
		print("URL �����݂���̂ŁA�f�[�^���擾���܂��B")
		r = requests.get(http)
		content_type_encoding = r.encoding if r.encoding != 'ISO-8859-1' else None
		url = BeautifulSoup(r.content, 'html.parser', from_encoding=content_type_encoding)
		#�����X�^�[���̎擾
		pd_mname1 = url.find('h2', attrs={'class', 'title-bg mb-4'})
		pd_mname2 = re.sub(r'No\.[0-9]{1,4}\s', "", pd_mname1.get_text(strip=True))
		#print(pd_mname2)
		pd_dat_unit.append(pd_mname2)
		
		#���A�x�ƃR�X�g�̎擾
		pd_linedata1 = url.find('p', attrs={'class', 'mb-2'})
		pd_linedata2 = re.sub(r'\s', "", pd_linedata1.get_text(strip=True))
		re_temp = re.compile('^\/(\S+)\/�R�X�g:(\S+)')
		m = re_temp.match(pd_linedata2)
		pd_mrare = m.group(1)
		pd_mcost = m.group(2)
		#print(pd_mrare)
		#print(pd_mcost)
		pd_dat_unit.append(pd_mrare)
		pd_dat_unit.append(pd_mcost)
		
		#�����X�^�[�^�C�v�̎擾
		type_raw = url.find('p', attrs={'class', 'icon-mtype mb-3'})
		type_num = len(type_arr)
		chk_arr = ["---" for i in range(type_num)]
		type_all = type_raw.find_all('a')
		for type in type_all:
			pd_mtype = re.sub(r'�^�C�v', "", type.get_text(strip=True))
			for i in range(0, type_num):
				if pd_mtype == type_arr[i]:
					chk_arr[i] = pd_mtype
		pd_dat_unit.extend(chk_arr)
		
		#�����X�^�[�X�L���̎擾
		u_s = '---'
		l_s = '---'
		skill_tag = url.find_all('a')
		for url_sub in skill_tag:
			chk_str = url_sub.get_text(strip=True)
			ext_url = url_sub['href']
			#�X�L��
			if re.search('skill', ext_url) != None:
				u_s = chk_str
				#print(u_s)
			#���[�_�[�X�L��
			elif re.search('leader', ext_url) != None:
				l_s = chk_str
				#print(l_s)
		pd_dat_unit.append(u_s)
		pd_dat_unit.append(l_s)

		#�����X�^�[�p�����[�^�̎擾
		pd_mstatus = [0 for i in range(12)]
		pd_mtable = url.find('table', attrs={'class':'table-monster-status'})
		rows = pd_mtable.find_all('tr')
		pd_mpara = []
		for row in rows:
			pdRow = []
			for cell in row.find_all(['td', 'th']):
				pdRow.append(cell.get_text(strip=True))
			#print(pdRow)
			if pdRow[0] != "":
				for i in range(2,len(pdRow)):
					pd_mpara.append(pdRow[i])
		for j in range (0,len(pd_mpara)):
			pd_mstatus[j] = pd_mpara[j]
		pd_dat_unit.extend(pd_mstatus)
		#print(linedata)
		
		#�o���X�L���̎擾
		kakusei_num = len(kakusei_arr)
		kakusei_all = ["---" for i in range(kakusei_num)]
		div_all = url.find_all('div', attrs={'class':'name'})
		for kakusei_ul in div_all:
			#�o���X�L�����܂܂��v�f�̃e�L�X�g���o��
			div_text = kakusei_ul.get_text(strip=True)
			for i in range(0, kakusei_num):
				if kakusei_arr[i] == div_text:
					kakusei_all[i] = div_text
					break
			#pd_mkakusei = kakusei_ul.find('div', attrs={'class':'name'})
			#print(pd_mkakusei)
		pd_dat_unit.extend(kakusei_all)
	else:
		print("URL �����݂��Ȃ��̂ŁA�X�L�b�v���܂��B")
		pd_dat_unit.append("No Data")
	#�����̕�����̕ϊ�
	maped_list = map(str, pd_dat_unit)
	linedata = '\t'.join(maped_list)
	print(linedata)
	print('\n')
	return linedata

def Get_PDKakusei_Inf(root_http):
	http = root_http + '/kakusei/list'
	ret = Check_url(http)
	result = []
	if ret == "OK":
		print("URL �����݂���̂ŁA�f�[�^���擾���܂��B")
		r = requests.get(http)
		content_type_encoding = r.encoding if r.encoding != 'ISO-8859-1' else None
		url = BeautifulSoup(r.content, 'html.parser', from_encoding=content_type_encoding)
		div_all = url.find_all('div', attrs={'class':'name'})
		for div_unit in div_all:
			#print(div_unit.get_text(strip=True))
			result.append(div_unit.get_text(strip=True))
	else:
		print("URL �����݂��Ȃ��̂ŁA�X�L�b�v���܂��B")
	return result

pd_root = 'http://pd.appbank.net'
#�o���X�L���̎擾
KakuseiArr = []
KakuseiArr = Get_PDKakusei_Inf(pd_root)
#for kakusei in KakuseiArr:
#	print(kakusei)
#�S�����X�^�[�^�C�v�̐ݒ�
TypeArr = [
	"�h���S��", "�̗�", "�U��", "��", "�o�����X", "�_", "����", "�}�V��", 
	"���������p�����X�^�[", "�i���p�����X�^�[", "�o���p�����X�^�[", "���p�p�����X�^�["
]
#print(Get_PDMonster_Inf(pd_root, 32, TypeArr, KakuseiArr))
#print('\n')
#print(Get_PDMonster_Inf(pd_root, 797, TypeArr, KakuseiArr))
#print('\n')
#print(Get_PDMonster_Inf(pd_root, 3388, TypeArr, KakuseiArr))

pd_data_list = []
for i in range(0, 5000):
	m_num = i + 1
	result = Get_PDMonster_Inf(pd_root, m_num, TypeArr, KakuseiArr)
	pd_data_list.append(result)

# �f�[�^�̏�������
fname = dat_dir + '\\' + 'PD_Monster_Dat.tsv'
f = codecs.open(fname, "w", "cp932", "ignore")
for linedata in pd_data_list:
	f.write(linedata)
	f.write('\n')
	
f.close()

#print(fname)
print('�f�[�^�̎擾���I���܂����B')

sys.exit()