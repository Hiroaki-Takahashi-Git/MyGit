#coding:	cp932
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
HTTP	=	args[0]

# URLの有無を確認する
def Check_url(in_http):
	try:
		resp = request.urlopen(in_http)
		resp.close()
		return "OK"
	except request.HTTPError:
		return "NG"

def GET_URL_DATA(IN_HTTP):
    pass
    ret	= Check_url(IN_HTTP)
    #print(ret);
    if ret == "OK":
        #print("URL が存在するので、データを取得します。")
        r = requests.get(IN_HTTP)
        content_type_encoding = r.encoding if r.encoding != 'ISO-8859-1' else None
        url = BeautifulSoup(r.content, 'html.parser', from_encoding=content_type_encoding)
        #print(url)
        return(url)
    else:
    	return("NODATA")

# GET_URL_DATA関数の
if __name__=="__GET_URL_DATA__":
    GET_URL_DATA(HTTP)
