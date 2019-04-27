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
		print("URL が存在するので、ダウンロードします。")
		url = BeautifulSoup(request.urlopen(http), 'html.parser')
		# パズドラモンスター名を出力
		print(url.title.text)
	
		div_all = url.find_all('div', attrs={'class':'monster'})

		# 画像の URL を表示
		for _div in div_all:
			res = _div.img['src']
			print(res)
		
			# 画像の書き込み
			print("画像を保存します。")
			save_fname = 'Monster%06d.jpg' % num
			out_img_name = dirname + '\\' + save_fname
			print(out_img_name)
			img_flg = os.path.exists(out_img_name)
			if img_flg == True:
				print('既にファイルが存在しているので、スキップします。')
			else:
				print('ファイルが存在してないので、ダウンロードします。')
				# 画像の URL が存在するか確認
				ret = Check_url(res)
				if ret == "OK":
					print("URL が見つかりました。")
					req = request.urlopen(res)
					f = open(out_img_name, "wb")
					f.write(req.read())
					f.close()
				else:
					print("URL が見つかりませんでした。")
	else:
		print("URL が存在しないので、スキップします。")
	print('\n')

pd_root = 'http://pd.appbank.net'
for i in range(0, 100):
	m_num = i + 1
	print('モンスター番号：' + str(m_num))
	Get_PDMonster_Inf(pd_root, m_num, img_dir)

sys.exit()