

file_dir = "E:\\insurance\\shan_cn_language_packages"

def work_dir(file_dir):
    for root, dirs, files in os.walk(file_dir):
        print ( "root : {0}".format(root) )
        print ( "dirs : {0}".format(dirs) )
        print ( "files : {0}".format(files) )

import os
        
    
def file_name(file_dir,file_kind="all"):   
    L=[]   
    for dirpath, dirnames, filenames in os.walk(file_dir):  
        for file in filenames :  
            if os.path.splitext(file)[1] == '.R':  
                L.append(os.path.join(dirpath, file))  
    return L
           

file_dir

file_name(file_dir)


True or False


haha = os.walk(file_dir)

haha.dirpath
          
work_dir(file_dir)
