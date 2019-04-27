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

#自作の関数
module01 = __import__('01_Get_URL')

#コマンドライン引数
args = sys.argv
PD_NUMBER	=	args[1]

#パズル&ドラゴンズ　データベース　URL
PD_MAINURL = 'http://pd.appbank.net'

def main():
    pass

if __name__=="__main__":
    main()
