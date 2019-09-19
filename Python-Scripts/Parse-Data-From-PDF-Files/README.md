# Parse-Data-From-PDF-Files

Reading and searching through PDF files using Apache tika (Reading) and regex for searching.

Also using this 👇 to search for files in folders.

```filename = []
extensions = {}
source_dir = os.path.dirname(os.path.realpath(__file__))

for dirpath, dirnames, filenames in os.walk(source_dir):
    for dirname in [f for f in dirnames]:
        dirx = os.path.join(dirpath, dirname)
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
                    extensions[fileExtension] += 1```
