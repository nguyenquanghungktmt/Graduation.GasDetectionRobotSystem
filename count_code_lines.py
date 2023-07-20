import glob
import os

folder_path = './'
file_end = '/**/*.js'

# get all file end with js or py or dart
files = glob.glob(folder_path + file_end, recursive=True)
print('Number of files', len(files))
# print(files)


# count number of lines
count = 0
for filepath in files :
    if os.path.isfile(filepath):
        with open(filepath) as f:
            count += sum(1 for _ in f)
    
print('Number of lines:', count)

