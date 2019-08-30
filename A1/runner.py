## TO 40 min per person
## record time 
## pipe output from sml and write to csv
## o/p order karat, karat exception, fact, fact exception 

import os
import re
import subprocess
import time
from threading import Timer
from datetime import datetime

testcases = ['K1', 'K2', 'K3', 'K4', 'K5', 'KE1', 'KE2', 'KE3', 'F1', 'F2', 'F3', 'FE1']

def create_entry(results, testcase):
	if results.find(testcase) == -1:
		return 'F, '
	else:
		return 'T, '

def process_output(results):
	row = ''
	for testcase in testcases:
		row = row + create_entry(results, testcase)
	return row + '\n'


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

# create csv with heading row for results
row = 'Entry No, Name, ' + ', '.join(testcases) + '\n'
with open('results.csv','w') as fd:
    fd.write(row)

# # run ml files
# for subs in ml_subs:
# 	os.system('cp ' + testcase_path + 'helper.ml "' + subs + '"')
# 	os.system('cp ' + testcase_path + 'testcase.ml "' + subs + '"')

# kill = lambda process: process.kill()	# required for timer

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
	print('started at:',datetime.now())
	sml_exec = subprocess.Popen(['sml', 'Assignment-1.sml'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, stdin=subprocess.PIPE)
	stdout,stderr = sml_exec.communicate()
	print('finished at:',datetime.now())

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
	
	# create results from stdout
	row = sml_subs[subs].strip('.sml') + ', '	# get entry no from file number
	row = row + subs[2:].split('_')[0] + ', '	# get name from folder name
	row = row + process_output(str(stdout))

	# save results into CSV
	with open('results.csv','a') as fd:
		fd.write(row)


