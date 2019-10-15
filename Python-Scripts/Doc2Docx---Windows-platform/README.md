# Doc2Docx---Windows-platform

Convert doc to docx.

It also convert .pdf to .docx --change .doc to .pdf:

```
             if f.lower().endswith('.pdf') or f.lower().endswith('.pdf'):
                    filename.append(file_fullpath)
                    fname, fileExtension = os.path.splitext(f)
                    fileExtension = fileExtension.lower()
                    if fileExtension not in extensions:
                        extensions[fileExtension] = 0
                    extensions[fileExtension] += 1
```
