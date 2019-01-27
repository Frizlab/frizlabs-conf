#!/usr/bin/python
# -*- coding: utf-8 -*-
# vim: ts=3 sw=3 noet
# Adapted from https://github.com/wincent/wincent

from __future__ import print_function

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


def raw_input_stderr(*args):
	old_stdout = sys.stdout
	try:
		sys.stdout = sys.stderr
		return raw_input(*args)
	finally:
		sys.stdout = old_stdout


def get_group_no_cache():
	# To get the hostname if we want to do some “smart” group detection…
	#host = socket.gethostname()
	
	group_input_str  = "What group is your computer in?\n\n"
	group_input_str += "Choose a number (group will be “unknown” if any other value is given):\n"
	for k in sorted(groups.keys(), key=int):
		group_input_str += "   %s) %s\n" % (k, groups[k])
	group_input_str += "\n"
	group_input_str += "Your choice: "
	
	group_number = raw_input_stderr(group_input_str)
	return groups.get(group_number, "unknown")


def get_cached_group():
	try:
		with file(cached_group_path) as f:
			s = f.read()
	except:
		return None
	return s.strip()


def update_cached_group(group):
	eprint("Updating cached group with new value: “%s”" % group)
	try:
		with open(cached_group_path, "w") as text_file:
			text_file.write(group)
	except:
		e = sys.exc_info()[0]
		eprint("   -> Failed with error %s" % str(e))


group = get_cached_group()
if group is None:
	group = get_group_no_cache()
	update_cached_group(group)
else:
	eprint("Using cached group: “%s”" % group)


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
