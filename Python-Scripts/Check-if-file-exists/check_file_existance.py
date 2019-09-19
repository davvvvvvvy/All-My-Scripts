import os
from tqdm import tqdm
import shutil
import re

def isUT(f, pattern=r'UT'):
    basename = os.path.basename(f)
    name, extension = os.path.splitext(basename)
    # print(basename)
    return re.search(pattern, basename, re.IGNORECASE)

def getUTfiles(directory):
    toreturn = []

    for path, dirs, files in os.listdir(directory):
        for f in files:
            if isUT(f):
                toreturn.append(os.path.join(path, f))

    return toreturn

log = open("logs.txt", 'a')
f = open(r"hyperlinks1233.txt", "r")
lines = f.read().split("\n")

# Folder destenation, copy files to that folder
dest = "C:\\Users\\ipi\\Desktop\\ffh"

i=1
j=0

for line in tqdm(lines):
    try:
        #os.startfile(line)
        #log.write("\n\nSuccessfully opened '{}' <{}>\n".format(line, i))

        try:

            

            for filename in os.listdir(line):
                fullfilename = os.path.join(line, filename)
                if os.path.isfile(fullfilename):
                    if isUT(fullfilename):
                        os.mkdir("{}\\{}".format(dest, i))
                        r = dest + "\\{}".format(i)
                        #shutil.copy(fullfilename, r)
                        log.write(r + "\n")
        except Exception as e:
            print(e)
            os.mkdir("{}\\{}".format(dest, i))
            r = dest + "\\{}".format(i)
            #shutil.copy(line, r)
            log.write(r + "\n")
            #log.write("[URL] {} || {}".format(line, e))

        

    except Exception as e:
        #log.write("\nError occupied in '{}' as <{}>".format(line, j))
        j+=1

    i+=1
