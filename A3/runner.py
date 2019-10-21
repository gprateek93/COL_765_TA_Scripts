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

sampletests = ['S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8', 'S9', 'S10', 'S11', 'S12']
testcases = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10' ,'T11']

def process_output(results):
	res_samples = results[results.find('sample: ')+len('sample: '):]
	row = res_samples[1: res_samples.find(']')]
	res_test = results[results.find('result: ')+len('result: '):]
	row = row + res_test[1: res_test.find(']')]
	return row + '\n'


ml_subs = {}
sml_subs = {}

print(os.system('pwd'))

# get paths to all the submissions
for path, dnames, fnames in os.walk('.'):
	for x in fnames:
		if x.endswith('.ml'):
			ml_subs[path] = x
		elif x.endswith('.sml') and x != "Assignment-1.sml":
			sml_subs[path] = x

print('sml:', len(sml_subs), sml_subs)

testcase_path = '/home/divyanjali/TA_Work/col765/COL_765_TA_Scripts/A3'

# create csv with heading row for results
row = 'Name, ' + ', '.join(sampletests) + ', '.join(testcases) + '\n'
with open('results.csv','w') as fd:
    fd.write(row)

kill = lambda process: process.kill()	# required for timer

for subs in sml_subs:
	print('\n\nchecking ', subs)
	# copy signature and testcase into student's folder
	os.system('cp ' + testcase_path + '/testcases.sml "' + subs + '"')
	os.system('cp ' + testcase_path + '/signatureFLX.sml "' + subs + '"')

	# execute the submission
	os.chdir(subs)
	# start_time = datetime.now()
	# print('started at:', start_time)
	sml_exec = subprocess.Popen(['sml', 'testcases.sml'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, stdin=subprocess.PIPE)
	stdout,stderr = sml_exec.communicate()

	# stop the process after 40 min
	# process_timer = Timer(40*60, kill, [sml_exec])
	# try:
	# 	process_timer.start()
	# 	stdout,stderr = sml_exec.communicate()
	# finally:
	# 	process_timer.cancel()


	# elapsed_time = datetime.now() - start_time
	print('stdout: ', stdout)
	print('stderr:', stderr)
	os.chdir("..")
	
	# create results from stdout
	# row = sml_subs[subs].strip('.sml') + ', '	# get entry no from file number
	row = subs[2:].split('_')[0] + ', '	# get name from folder name
	# row = row + str(elapsed_time) + ', '				
	row = row + process_output(str(stdout))

	# save results into CSV
	with open('results.csv','a') as fd:
		fd.write(row)


