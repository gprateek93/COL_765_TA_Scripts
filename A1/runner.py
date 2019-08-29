## TO 40 min per person
## record time 
## pipe output from sml and write to csv
## o/p order karat, karat exception, fact, fact exception 

import os
import re
import subprocess
import time
from threading import Timer


ml_subs = {}
sml_subs = {}

print(os.system('pwd'))

# Extract all files archive files
for path, dnames, fnames in os.walk('.'):
	for x in fnames:
		if x.endswith('.ml'):
			ml_subs[path] = x
		elif x.endswith('.sml') and x != "Assignment-1.sml":
			sml_subs[path] = x

# print('ml:', len(ml_subs))
# print('sml:', len(sml_subs), sml_subs)


testcase_path = '/home/divyanjali/TA_Work/col765/COL_765_TA_Scripts/A1'

# # run ml files
# for subs in ml_subs:
# 	os.system('cp ' + testcase_path + 'helper.ml "' + subs + '"')
# 	os.system('cp ' + testcase_path + 'testcase.ml "' + subs + '"')
kill = lambda process: process.kill()

for subs in sml_subs:
	print('\n\nchecking ', subs)
	os.system('cp ' + testcase_path + '/Test_Cases_fact.txt "' + subs + '"')
	os.system('cp ' + testcase_path + '/output_fact.txt "' + subs + '"')
	os.system('cp ' + testcase_path + '/Test_Cases_karat.txt "' + subs + '"')
	os.system('cp ' + testcase_path + '/output_karat.txt "' + subs + '"')
	os.system('cp ' + testcase_path + '/Assignment-1.sml "' + subs + '"')

	# change the use statement in Assignment-1.sml to use student's submission
	filename = subs + '/Assignment-1.sml'
	new_prgm = ''
	with open(filename, 'r') as files:
		org_prgm = files.read()
		new_prgm = org_prgm.replace('use "assignment.sml";', 'use "'+ sml_subs[subs] + '";')
	with open(filename, 'w') as files:
		files.write(new_prgm)

	# execute the submission
	os.chdir(subs)
	sml_exec = subprocess.Popen(['sml', 'Assignment-1.sml'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, stdin=subprocess.PIPE)
	# sml_exec = subprocess.Popen(['pwd'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, stdin=subprocess.PIPE)
	# sml_exec.stdin.write('use "Assignment-1.sml";')

	stdout,stderr = sml_exec.communicate()

	# stop it after 40 min
	# start_time = time.time()
	# process_timer = Timer(1, kill, [sml_exec])
	# try:
	# 	process_timer.start()
	# 	stdout,stderr = sml_exec.communicate()
	# 	elapsed_time = time.time() - start_time
	# finally:
	# 	process_timer.cancel()

	print('stdout: ', stdout)
	print('stderr:', stderr)
	# print('elapsed time:', elapsed_time)
	os.chdir("..")
	
