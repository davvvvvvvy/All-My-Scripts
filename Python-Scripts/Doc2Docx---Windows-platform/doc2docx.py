import glob
import win32com.client
import os
from tqdm import tqdm

filename = []
extensions = {}
source_dir = os.path.dirname(os.path.realpath(__file__))

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

                if f.lower().endswith('.doc') or f.lower().endswith('.doc'):
                    filename.append(file_fullpath)
                    fname, fileExtension = os.path.splitext(f)
                    fileExtension = fileExtension.lower()
                    if fileExtension not in extensions:
                        extensions[fileExtension] = 0
                    extensions[fileExtension] += 1

word = win32com.client.Dispatch("Word.Application")
#word.visible = 0

try:

    for doc in tqdm(filename):
        in_file = os.path.abspath(doc)
        wb = word.Documents.Open(in_file)
        out_file = os.path.abspath("{}.docx".format(os.path.splitext(os.path.basename(doc))[0]))
        wb.SaveAs2(out_file, FileFormat=16)
        wb.Close()

except:
    print("ERROR showed up :(0)")

word.Quit()
os.system("PAUSE")
