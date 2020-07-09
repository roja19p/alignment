import csv
import re

flag = 0
flag1 = 0
flagg = 0
list_P=['P']

try:
    f=open("word.dat",'r').readlines()
    n=len(f)-1
except:
    flag=1
    print("word.dat not found\n")
try:
    f6=open("word_alignment.dat",'r').readlines()
except:
    flag1=1
    print("word_alignment.dat not found\n")
try:
    g=open("manual_lwg.dat",'r').readlines()
    glen=len(g)
except:
    flagg=1
    print("manual_lwg.dat not found\n")

fw = open("p_layer.csv", "w")

for i in range(n):
    list_P.append("0")

if(flag1==0):#P_Layer
    n6=len(f6)
    for i in range(n6):
        res1=f6[i][1:]
        res2=res1[:-2]
        res3=re.split(r'-',res2)
        length=len(res3)
        anu_id=re.split(r'\s+',res3[4])[1]
        str1=""
        str2=""
        if(length>6):
            for j in range(5,length):
                if(res3[j]!=' '):
                    str1=str1+res3[j]+"-"
            str2=str1[:-1]
        elif(length==6):
            str2=res3[5]
        str3=str2[1:]
        myre=re.split(r'\s+',str3)
        try:
            myre.remove("-")
        except:
            print(" ")
        abc=len(myre)
#        print(myre)
#        print(abc)
        str5=""
        for k in range(1,abc):
            str5=str5+myre[k]+" "
        man_id=myre[0]
        str4=str5[:-1]
#        print(str4)
        for j in range(glen):
            res11=g[j][:-3]
            res12=res11[1:]
            res13=re.split(r'\)?\s\(',res12)
            res14=re.split(r'\s',res13[1])[-1]
            res15=res13[-1]
            res16=re.split(r'\s+',res15)
            length1=len(res16)
            str10=""
            for k in range(1,length1):
                str10=str10+res16[k]+" "
            if(res14==man_id):
                if('@PUNCT-OpenParen@PUNCT-OpenParen'in str4 and abc==2):
                    print("")
                else:
                    for k in range(1,n+1):
                        if(int(anu_id)==int(k)):
                            list_P[k]=str10[:-1]

fw.write(','.join(list_P)+'\n')                       
