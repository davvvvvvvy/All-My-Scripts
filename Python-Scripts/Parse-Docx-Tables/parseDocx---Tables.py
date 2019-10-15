import argparse
import re
import sys
import json
import pandas as pd

from tqdm import tqdm
import time

nsmap = {'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}

def getFileName(x):
    return os.path.basename(x)


source_dir = "C:\\Users\\ipi\\Desktop"


import zipfile
import xml.etree.ElementTree
import os

WORD_NAMESPACE = '{http://schemas.openxmlformats.org/wordprocessingml/2006/main}'
PARA = WORD_NAMESPACE + 'p'
TEXT = WORD_NAMESPACE + 't'
TABLE = WORD_NAMESPACE + 'tbl'
ROW = WORD_NAMESPACE + 'tr'
CELL = WORD_NAMESPACE + 'tc'

def parseDocument(docx_filename):    
    data = []
    with zipfile.ZipFile(docx_filename) as docx:
        tree = xml.etree.ElementTree.XML(docx.read('word/document.xml'))

    for table in tree.iter(TABLE):
        for row in table.iter(ROW):
            row_data = []
            row_data.append(docx_filename)
            for cell in row.iter(CELL):
                val = ''.join(node.text for node in cell.iter(TEXT))
                row_data.append(val)            
            data.append(row_data)
            
    return data

def getFiles(in_dir, extension='.docx'):

    filelist = []
    extensions = {}
 
    import os
    import os.path

    for dirpath, dirnames, filenames in os.walk(in_dir):

        for dirname in [f for f in dirnames]:
            dirx = os.path.join(dirpath, dirname)        

            files = os.listdir(dirx)
            for f in files:            
                if not f.startswith('~'):
                    file_fullpath = dirx + "\\" + f
                    if os.path.isdir(file_fullpath):
                        continue
                    
                    if not f.endswith(extension):
                        continue
                        
                    filelist.append(file_fullpath)
                    fname, fileExtension = os.path.splitext(f)
                    fileExtension = fileExtension.lower()
                    if fileExtension not in extensions:
                        extensions[fileExtension] = 1
                    extensions[fileExtension] += 1

    return filelist, extensions

filelist, extensions = getFiles(source_dir)

print(filelist)

check_it = True
check_it = False

final = []    
errors = []

with tqdm(total=len(filelist)) as pbar:
    for file in filelist:

        data = parseDocument(file)

        final.append(data)
        pbar.update()

        if check_it:
            break



len(final)
final[0][25]
len(final[0][25])
nlen = set(list(len(n) for node in final for n in node))
nlen
m = max(len(n) for node in final for n in node)
print(m)


N = 20
new_data = []
for node in final:
    for dx in node:
        if len(dx) > N:
            continue
        arr = list(dx[1:])
        absfname = dx[0]
        fname = getFileName(absfname)
        for i in range(len(arr), N):
            arr.append('')
        arr.append(fname)
        arr.append(absfname)
        new_data.append(arr)   



new_data[:3]
print(max(len(node) for node in new_data))

len(errors)

errors




import pandas as pd
import numpy as np

x = pd.DataFrame(data=np.array(new_data))

x.shape

def remSP(x):
    if type(x) == str:
        return x.strip()
    return x

x = x.replace(r'^\s+$', np.nan, regex=True)

x = x.apply(remSP)

x.head()

x.dropna(inplace=True,subset=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20],how='all',axis=0)

x[x[21] == 'D-0706UTCON.docx']

x[x[21] == 'D-0706UTCON.docx']

x[x[21] == 'D-0706UTCON.docx'].shape

x.columns.tolist()

ofile = r"C:/Users/ipi/Desktop/UT_measurements.xlsx"

x.to_excel(ofile, index=False)