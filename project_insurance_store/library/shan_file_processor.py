import os
import shutil
import csv

def shan_move_file(from_path:str,to_path:str):

    path_xml = from_path #windows系统用双斜线
    filelist = os.listdir(path_xml)

    path1 = from_path
    path2 = to_path

    for files in filelist:
        filename1 = os.path.splitext(files)[1]  # 读取文件后缀名
        filename0 = os.path.splitext(files)[0]  #读取文件名
        print(filename1)
        m = filename1 == '.csv'
        print(m)
        if m :
            full_path = os.path.join(path1, files)
            despath = path2 + filename0+'.csv' #.csv为你的文件类型，即后缀名，读者自行修改
            shutil.move(full_path, despath)
        else :
                continue

def shan_copy_file(from_path:str,to_path:str):

    path_xml = from_path #windows系统用双斜线
    filelist = os.listdir(path_xml)

    path1 = from_path
    path2 = to_path

    for files in filelist:
        filename1 = os.path.splitext(files)[1]  # 读取文件后缀名
        filename0 = os.path.splitext(files)[0]  #读取文件名
        print(filename1)
        m = filename1 == '.csv'
        print(m)
        if m :
            full_path = os.path.join(path1, files)
            despath = path2 + filename0+'.csv' #.csv为你的文件类型，即后缀名，读者自行修改
            shutil.copy(full_path, despath)
        else :
                continue
            
def shan_python_read_csv(filepath:str,Encode="utf-8") -> list:

    with open(filepath,"r",encoding=Encode) as csvfile:
        #读取csv文件，返回的是迭代类型
        reader = csv.reader(csvfile, delimiter=',')
        output = list(reader)

        return(output)  
        
def shan_get_file_name(file_dir):   
    L=[]   
    for dirpath, dirnames, filenames in os.walk(file_dir):  
        for file in filenames :  
            if (os.path.splitext(file)[1] == '.doc') or (os.path.splitext(file)[1] == '.pdf'):  
                L.append(os.path.join(dirpath, file))  
    return L