import texttable as ttb

def MAKE_MATRIX(COL_ARR, IN_ARR):
	TBL = ttb.Texttable()
	
	ALL = []
	ALL.append(COL_ARR)
	IN_C = len(COL_ARR)
	IN_R = int(len(IN_ARR) / IN_C)
	#TBL.add_rows(COL_ARR)
	
	for j in range(0, IN_R):
		RLINEDATA = []
		for i in range(0, IN_C):
			IDX = IN_C * j + i
			RLINEDATA.append(IN_ARR[IDX])
		ALL.append(RLINEDATA)
	
	#print(ALL)
	TBL.add_rows(ALL)
	return TBL
	