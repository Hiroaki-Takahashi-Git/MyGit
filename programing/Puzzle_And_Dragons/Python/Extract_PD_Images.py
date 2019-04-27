# coding: cp932
from bs4 import BeautifulSoup
from urllib import request
import sys
import types
import os

args = sys.argv
img_dir = args[1]

def Check_url(http):
	try:
		resp = request.urlopen(http)
		resp.close()
		return "OK"
	except request.HTTPError:
		return "NG"

def Get_PDMonster_Inf(root_http, num, dirname):
	pd_num = '%03d' % num
	http = root_http + '/m' + pd_num
	ret = Check_url(http)
	if ret == "OK":
		print("URL �����݂���̂ŁA�_�E�����[�h���܂��B")
		url = BeautifulSoup(request.urlopen(http), 'html.parser')
		# �p�Y�h�������X�^�[�����o��
		print(url.title.text)
	
		div_all = url.find_all('div', attrs={'class':'monster'})

		# �摜�� URL ��\��
		for _div in div_all:
			res = _div.img['src']
			print(res)
		
			# �摜�̏�������
			print("�摜��ۑ����܂��B")
			save_fname = 'Monster%06d.jpg' % num
			out_img_name = dirname + '\\' + save_fname
			print(out_img_name)
			img_flg = os.path.exists(out_img_name)
			if img_flg == True:
				print('���Ƀt�@�C�������݂��Ă���̂ŁA�X�L�b�v���܂��B')
			else:
				print('�t�@�C�������݂��ĂȂ��̂ŁA�_�E�����[�h���܂��B')
				# �摜�� URL �����݂��邩�m�F
				ret = Check_url(res)
				if ret == "OK":
					print("URL ��������܂����B")
					req = request.urlopen(res)
					f = open(out_img_name, "wb")
					f.write(req.read())
					f.close()
				else:
					print("URL ��������܂���ł����B")
	else:
		print("URL �����݂��Ȃ��̂ŁA�X�L�b�v���܂��B")
	print('\n')

pd_root = 'http://pd.appbank.net'
for i in range(0, 100):
	m_num = i + 1
	print('�����X�^�[�ԍ��F' + str(m_num))
	Get_PDMonster_Inf(pd_root, m_num, img_dir)

sys.exit()