import os
import subprocess
import sys

#git clone https://github.com/SpiderLabs/owasp-modsecurity-crs /opt/owasp-modsecurity-crs
start_folder="/opt/owasp-modsecurity-crs/rules/"
command="/opt/waflz/build/util/waflz_dump/waflz_dump --input={0} --json"
output_location = "/opt/owasp-modsecurity-crs/version/v3.2-dev/policy/"
for filename in os.listdir(start_folder):
	if filename[-5:] == ".conf":
		full_file_path = start_folder + filename
		command = command.format(full_file_path)
		split_cmd = command.split(' ')
		p = subprocess.Popen(split_cmd, stdout=subprocess.PIPE)
		json_out = p.communicate()[0]
		f = open(output_location+filename + ".json", 'w')
		f.write(str(json_out))
		f.close()
