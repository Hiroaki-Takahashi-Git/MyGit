import sys
constant = __import__('Set_PD_Constant')

args = sys.argv
IN_NUMBER = args[1]

def SET_PDNUM(IN_NUM):
	EXT_NUM = '%03d' % int(IN_NUM)
	PD_URL = constant.PD_DB_URL + '/m' + EXT_NUM
	return(PD_URL)

def main(IN_NUM):
    pass
    #print(constant.PD_DB_URL)
    #EXT_NUM = '%03d' % int(IN_NUM)
    #PD_URL = constant.PD_DB_URL + '/m' + EXT_NUM
    #print(PD_URL)
    #return(PD_URL)
    TEST_URL = SET_PDNUM(IN_NUM)
    print(TEST_URL)

if __name__=="__main__":
    main(IN_NUMBER)
