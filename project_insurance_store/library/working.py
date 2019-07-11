import sys
import pickle
import re
import  codecs
import string
import shutil
from win32com import client as wc
import docx


def doSaveAas(filein,fileout):   
    word = wc.Dispatch('Word.Application')
    doc = word.Documents.Open(filein)        # 目标路径下的文件
    doc.SaveAs(fileout, 12, False, "", True, "", False, False, False, False)  # 转化后路径下的文件    
    doc.Close()
    word.Quit()
    
def shan_get_first_word(doc):
    file=docx.Document(doc)
    return file.paragraphs[0].text



