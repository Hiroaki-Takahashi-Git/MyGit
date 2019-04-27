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

def Check_url(http):
	try:
		resp = request.urlopen(http)
		resp.close()
		return "OK"
	except request.HTTPError:
		return "NG"

def Get_PDMonster_Inf(root_http, num):
	pd_dat_unit = []
	pd_dat_unit.append(num)
	pd_num = '%03d' % num
	http = root_http + '/m' + pd_num
	ret = Check_url(http)
	if ret == "OK":
		print("URL が存在するので、データを取得します。")
		r = requests.get(http)
		content_type_encoding = r.encoding if r.encoding != 'ISO-8859-1' else None
		url = BeautifulSoup(r.content, 'html.parser', from_encoding=content_type_encoding)
		#print(content_type_encoding)
		div_all = url.find_all('div', attrs={'class':'monster'})
		for div_unit in div_all:
#			print(div_unit)
			# モンスター名
			pd_mname = div_unit.find('h2', attrs={'class':'title-bg mb-4'})
			print(pd_mname.get_text(strip=True))
			pd_mname_re = re.sub(r'No\.[0-9]+\s', "", pd_mname.get_text(strip=True))
			pd_dat_unit.append(pd_mname_re)
			# モンスターステータス
			pd_mstatus = div_unit.find_all('p', attrs={'class':'mb-2'})
			u_s = 'NoData'
			l_s = 'NoData'
			for stat in pd_mstatus:
				stat2 = re.sub(r'\s', "", stat.get_text(strip=True))
				# レア度＆コスト
				str_ret = re.search('コスト', stat2)
				if str_ret != None:
					re_temp = re.compile('^\/(\S+)\/(\S+)')
					m = re_temp.match(stat2)
					pd_mrare = m.group(1)
					pd_mcost = re.sub(r'コスト:', "", m.group(2))
					pd_dat_unit.append(pd_mrare)
					pd_dat_unit.append(pd_mcost)
				# スキル
				skill_tag = stat.find_all('a')
				for url_sub in skill_tag:
					chk_str = url_sub.get_text(strip=True)
					ext_url = url_sub['href']
					if re.search('skill', ext_url) != None:
						u_s = chk_str
						print(u_s)
					elif re.search('leader', ext_url) != None:
						l_s = chk_str
						print(l_s)
			pd_dat_unit.append(l_s)
			pd_dat_unit.append(u_s)
			# モンスターのパラメータ
			pd_mtable = div_unit.find('table', attrs={'class':'table-monster-status'})
			rows = pd_mtable.find_all('tr')
			for row in rows:
				pdRow = []
				for cell in row.find_all(['td', 'th']):
					pdRow.append(cell.get_text(strip=True))
				print(pdRow)
				if pdRow[0] != "":
					for i in range(2,len(pdRow)):
						pd_dat_unit.append(pdRow[i])
		maped_list = map(str, pd_dat_unit)
		linedata = '\t'.join(maped_list)
		#print(linedata)
	else:
		print("URL が存在しないので、スキップします。")
		linedata = ""
	return linedata
	print('\n')

def Get_PDKakusei_Inf(root_http):
	http = root_http + '/kakusei/list'
	ret = Check_url(http)
	result = []
	if ret == "OK":
		print("URL が存在するので、データを取得します。")
		r = requests.get(http)
		content_type_encoding = r.encoding if r.encoding != 'ISO-8859-1' else None
		url = BeautifulSoup(r.content, 'html.parser', from_encoding=content_type_encoding)
		div_all = url.find_all('div', attrs={'class':'name'})
		for div_unit in div_all:
			#print(div_unit.get_text(strip=True))
			result.append(div_unit.get_text(strip=True))
	else:
		print("URL が存在しないので、スキップします。")
	return result

pd_root = 'http://pd.appbank.net'
#覚醒スキルの取得
KakuseiArr = []
KakuseiArr = Get_PDKakusei_Inf(pd_root)
for kakusei in KakuseiArr:
	print(kakusei)
#print(Get_PDMonster_Inf(pd_root, 2804))
#pd_data_list = []
#for i in range(0, 5000):
#	m_num = i + 1
#	result = Get_PDMonster_Inf(pd_root, m_num)
#	pd_data_list.append(result)
#
## データの書き込み
#fname = dat_dir + '\\' + 'PD_Monster_Dat.tsv'
#f = codecs.open(fname, "w", "cp932", "ignore")
#for linedata in pd_data_list:
#	f.write(linedata)
#	f.write('\n')
#	
#f.close()
#
##print(fname)
#print('データの取得が終わりました。')

sys.exit()