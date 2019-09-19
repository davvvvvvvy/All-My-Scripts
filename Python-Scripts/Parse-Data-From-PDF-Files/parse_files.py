import os
import tika
from tqdm import tqdm
import array

tika.initVM()

from tika import parser
import re
import csv

import datefinder
import subprocess

import PyPDF2

log = open("miskar_logs.txt", "a")

filename = []
extensions = {}
source_dir = os.path.dirname(os.path.realpath(__file__)) # __file__

for dirpath, dirnames, filenames in os.walk(source_dir):
    for dirname in [f for f in dirnames]:
        dirx = os.path.join(dirpath, dirname)
        print(dirx)
        files = os.listdir(dirx)
        for f in files:
            if not f.startswith('~'): # skip file created when file is open
                file_fullpath = dirx + "\\" + f

                if os.path.isdir(file_fullpath):
                    continue

                if f.lower().endswith('.pdf') or f.lower().endswith('.pdf'):
                    filename.append(file_fullpath)
                    fname, fileExtension = os.path.splitext(f)
                    fileExtension = fileExtension.lower()
                    if fileExtension not in extensions:
                        extensions[fileExtension] = 0
                    extensions[fileExtension] += 1

def parsePDF(filename):

    title = subprocess.check_output('py -m pdftitle -p "{}"'.format(filename), shell=True)

    with open(filename, mode='rb') as ff:
        reader = PyPDF2.PdfFileReader(ff)
        page = reader.getPage(0)
        textPDF = page.extractText()

    pars = parser.from_file(filename)
    parsed = pars['content']

    try:
        for i in range(0, len(titles)):
            if re.search(i, parsed) == True:
                title = tit[i]
    except:
        pass

    try:
        tagNo = re.search("Tag number", parsed)
        #print("[INFO ] Found by 'Tag number' {}".format(tagNo))
        a=[]
        a.append(tagNo.span())
        a = [x for xs in a for x in xs]
        T = parsed[a[1]+1:a[1]+8+5].strip() # varira izmedu 8 i 12

    except:

        tagNo = re.search("TAG  No.", parsed)
        #print("[INFO ] Found by 'TAG No' {}".format(tagNo))
        a=[]
        a.append(tagNo.span())
        a = [x for xs in a for x in xs]
        T = parsed[a[1]+1:a[1]+8].strip() # varira izmedu 8 i 12

    m = datefinder.find_dates(textPDF)
    date=[]
    for mm in m:
        date.append(mm)

    try:
        Inspector = re.search("Inspectors", parsed)
        #print("[INFO ] Found by 'Inspector' {}".format(Inspector))
        a=[]
        a.append(Inspector.span())
        a = [x for xs in a for x in xs]
        if "Signature" or "Signature" in parsed[a[1]+1:a[1]+12]:
            I = parsed[a[1]+7:a[1]+24+24+24].strip() # varira izmedu 8- 12
        else:
            I = parsed[a[1]+7:a[1]+24].strip()

    except:
        Inspector = re.search("Inspector", parsed)
        #print("[INFO ] Found by 'Inspectors' {}".format(Inspector))
        a=[]
        a.append(Inspector.span())
        a = [x for xs in a for x in xs]
        I = parsed[a[1]+7:a[1]+24].strip()

    csvData = [[title.strip(), "Miskar Platform", date[2].strftime("%d/%m/%y"), T, I, filename], [title, "Miskar Platform", date[2].strftime("%d/%m/%y"), T, I, filename]]
    create_csv(csvData)

def create_csv(csvData):
    with open('Vessel-Miskar.csv', 'a') as csvFile:
        writer = csv.writer(csvFile)
        writer.writerows(csvData)

    csvFile.close()

for i in tqdm(range(0, len(filename))):
    try:
        parsePDF(filename[i])

    except Exception as e:
        log.write("[INFO ] <{}> didn't parse {}\n[ERROR] {}\n".format(filename[i], i, e))

log.close()
os.system("PAUSE")
