#coding:	cp932
from bs4 import BeautifulSoup
from urllib import request
import sys
import types
import os
import numpy as np
import re
import requests
import codecs
#import cv2

#自作の関数
module01 = __import__('01_Get_URL')
module02 = __import__('Set_PD_Constant')
module03 = __import__('Set_PD_Number')

#コマンドライン引数
args = sys.argv
PD_NUMBER	=	args[1]

#モンスターの画像を取得する
def PD_GET_IMAGE(IN_TAG):
    try:
        IMAGE_TAG = IN_TAG.find('img', attrs={'class':'image-responsive mb-3'})
        IMAGE_URL = IMAGE_TAG.get("src")
        print(IMAGE_URL)
        return(IMAGE_URL)
    except :
        return("NO_IMAGE_URL")

def main(NUMBER):
    pass
    PD_HTTP = module03.SET_PDNUM(NUMBER)
    PD_URL = module01.GET_URL_DATA(PD_HTTP)
    TEST_IMAGE = PD_GET_IMAGE(PD_URL)
    print(TEST_IMAGE)
    # IDX = '%06d' % int(NUMBER)
    # #print(IDX)
    # TEST_NAME = "TEST_IMAGE_No" + IDX + ".jpg"
    # #print(TEST_NAME)
    # TEST_RES = requests.get(TEST_IMAGE)
    # with open(TEST_NAME, 'wb') as f:
    # 	f.write(TEST_RES.content)
    # # TEST_MAT = cv2.imread(TEST_NAME)
    # # cv2.imshow("GetImage", TEST_MAT)
    # # cv2.waitKey(0)
    # # cv2.destroyWindow("GetImage")

if __name__=="__main__":
    main(PD_NUMBER)
