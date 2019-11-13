import os
import re

count = 0
sha_unmatch = 0
zip_count = 0
err_count = 0
err = []

wrong_ext_list = open('wrong_ext_submissions', 'w')

print(os.system('pwd'))

# Extract all files archive files
for path, dnames, fnames in os.walk('.'):
	# print ('path: ', path)
	if 'moodle' in path:
		continue
	if 'old' in path:
		continue
	for x in fnames:
		# print('fname:', x)
		# Extract all zip files and add names to zip_file list
		if x.endswith('.zip'):
			zip_file = os.path.join(path, x)
			print("Extracting zip ", zip_file)
			if os.system('unzip -o "' + zip_file + '" -d "' + path + '" > /dev/null') == 0:
				zip_count = zip_count + 1
				count = count  + 1
				# zipped_list.write(path+'\n')
		elif x.endswith('.tgz'):
			tgz_file = os.path.join(path, x)
			print("Extracting ", tgz_file)
			if os.system('tar -xf "' + tgz_file + '" --directory "' + path + '" > /dev/null') == 0:
				count = count  + 1
				wrong_ext_list.write(path + ', tar.gz'+'\n')
			elif os.system('unzip -o "' + zip_file + '" -d "' + path + '" > /dev/null') == 0:
				print('Not tgz')
				zip_count = zip_count + 1
				wrong_ext_list.write(path + ', tgz but zip'+'\n')
		elif x.endswith('.tar.gz'):
			tgz_file = os.path.join(path, x)
			print("Extracting ", tgz_file)
			if os.system('tar -xf "' + tgz_file + '" --directory "' + path + '"') == 0:
				count = count  + 1
				wrong_ext_list.write(path + ', tar.gz'+'\n')
		elif not x.endswith('sml'):
			err_count = err_count +1
			err.append(path)


wrong_ext_list.close()
print("No of extracted files: ", count)
print("No of zips extraxted: ", zip_count)
print("No of errs: ", err_count)
print(err)
