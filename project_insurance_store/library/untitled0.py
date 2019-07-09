# -*- coding: utf-8 -*-
"""
Created on Tue Jul  9 19:28:18 2019

@author: zhong
"""

        
os.getcwd()    
os.chdir('E:\\insurance\\file')    

data = pandas.read_csv("E:\\insurance\\file\\pingan.csv")

a = range(len(data.name))

for i in a:
    data.name[i] = re.sub("\d+[.]","",data.name[i])
    data.name[i] = re.sub(" ","",data.name[i])

    
for i in a:
    getFile(data.link[i],data.name[i])
    
