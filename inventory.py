#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# vim: ts=3 sw=3 noet
# Adapted from https://github.com/wincent/wincent

import json
import os
import re
import socket
import sys


##################
##     Conf     ##
##################

cached_group_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), ".ansible_group")
groups = {
	"1": "home",
	"2": "work"
}


##################
##     Code     ##
##################

def eprint(*args, **kwargs):
	print(*args, file=sys.stderr, **kwargs)


def input_stderr(*args):
	old_stdout = sys.stdout
	try:
		sys.stdout = sys.stderr
		return input(*args)
	finally:
		sys.stdout = old_stdout


def get_group_no_cache():
	# To get the hostname if we want to do some "smart" group detection…
	#host = socket.gethostname()
	
	group_input_str  = "What group is your computer in?\n\n"
	group_input_str += "Choose a number (group will be \"unknown\" if any other value is given):\n"
	for k in sorted(groups.keys(), key=int):
		group_input_str += "   %s) %s\n" % (k, groups[k])
	group_input_str += "\n"
	group_input_str += "Your choice: "
	
	group_number = input_stderr(group_input_str)
	return groups.get(group_number.strip(), "unknown")


def get_cached_group():
	try:
		with open(cached_group_path, "r") as f:
			s = f.read()
		return s.strip()
	except:
		return None


# Returns True on success, False on failure
def update_cached_group(group):
	print("Updating cached Ansible group with new value: \"%s\"" % group)
	try:
		with open(cached_group_path, "w") as text_file:
			text_file.write(group)
		return True
	except:
		e = sys.exc_info()[0]
		eprint("   -> Failed cache update with error %s" % str(e))
		return False



update_cache_only = False
if len(sys.argv) >= 2:
	update_cache_only = (sys.argv[1] == "--update-cache-only")


group = get_cached_group()
if group is None:
	group = get_group_no_cache()
	did_update = update_cached_group(group)
	if update_cache_only:
		sys.exit(0 if did_update else 1)
else:
	# Printing to stderr will print an error in Ansible; printing on stdout will
	# make Ansible fail (will try to parse this as part of the expected JSON).
	if update_cache_only:
		print("Using cached group: \"%s\"" % group)
		sys.exit(0)


inventory = {
	group: {
		"hosts": [
			"localhost"
		],
		"vars": {
			"ansible_connection": "local"
		}
	}
}
print(json.dumps(inventory))
