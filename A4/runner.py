import os
import re
import subprocess
import time
from threading import Timer
from datetime import datetime

numtests = 21

testcases = ['T'+str(i) for i in range(1,numtests+1)]

def process_output(results):
	res_test = results[results.find('result: ')+len('result: '):]
	row = res_test[1: res_test.find(']')]
	return row + '\n'


ml_subs = {}
sml_subs = {}

# get paths to all the submissions
for path, dnames, fnames in os.walk('.'):
	if 'moodle' in path or 'old' in path or '__MACOSX' in path:
		continue
	for x in fnames:
		if x.endswith('.ml'):
			ml_subs[path] = x
		elif x.endswith('.sml'):
			sml_subs[path] = x
			# if structureFLX.sml is not in submission directory, create an empty file
			if 'structureFLX.sml' not in fnames:
				# print('structureFLX.sml not found in', path, ' Creating empty')
				os.system('touch "' + path + '/structureFLX.sml"')

print('sml:', len(sml_subs), sml_subs)

testcase_path = '/home/divyanjali/TA_Work/col765/COL_765_TA_Scripts/A4'

# create csv with heading row for results
row = 'Name, ' + ', '.join(testcases) + '\n'
with open('results.csv','w') as fd:
    fd.write(row)

rootdir = os.getcwd()

for subs in sml_subs:
	print('\n\nchecking ', subs)
	# copy signature and testcase into student's folder
	os.system('cp ' + testcase_path + '/testcases.sml "' + subs + '"')
	os.system('cp ' + testcase_path + '/signatureLAMBDAFLX.sml "' + subs + '"')
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
	os.chdir(rootdir)
	
	# create results from stdout
	# row = sml_subs[subs].strip('.sml') + ', '	# get entry no from file number
	row = subs[2:].split('_')[0] + ', '	# get name from folder name
	# row = row + str(elapsed_time) + ', '				
	row = row + process_output(str(stdout))

	# save results into CSV
	with open('results.csv','a') as fd:
		fd.write(row)


