#!/usr/bin/env python
# -*- coding: utf-8 -*-

# merge-strings.py - Merge of Mac OS/iOS localization files
# François Lamboley, 2014 http://www.frostland.fr/

# Originally based on Localize.py, by João Moreno (in 2009)
# http://joaomoreno.com/

# Almost everything (even the parser) has been re-written



from sys import argv
from copy import copy
from codecs import open
import sys
import os
import re



class LocalizedString():
	def __init__(self):
		self.key = u''
		self.value = u''
		self.comment = u''
		self.between = u''
		self.semicolon = u''
		self.finished = False
	
	def __unicode__(self):
		if not self.finished: return self.comment
		return u'%s"%s"%s"%s"%s' % (self.comment, self.key, self.between, self.value, self.semicolon)



class LocalizedFile():
	def __init__(self, fname = None):
		self.strings = []
		self.strings_d = {}
		self.endOfFile = LocalizedString()
		
		if fname != None and not self.read_from_file(fname):
			raise Exception("Cannot read file")
	
	def confirm_end_comment(self, c):
		self.localizedString.comment = self.localizedString.comment + c
		
		if c == u'/': self.engine = self.treat_idle_char
		else:         self.engine = self.wait_end_comment
		return True
	
	def wait_end_comment(self, c):
		self.localizedString.comment = self.localizedString.comment + c
		
		if c != u'*': return True
		self.engine = self.confirm_end_comment
		return True
	
	def confirm_comment_start(self, c):
		if c != u'*': return False
		
		self.engine = self.wait_end_comment
		self.localizedString.comment = self.localizedString.comment + c
		return True
	
	def treat_semicolon_char(self, c):
		if c == u'\n' or c == u'\t' or c == u' ':
			self.localizedString.semicolon = self.localizedString.semicolon + c
			return True
		if c == u';':
			self.localizedString.finished = True
			self.localizedString.semicolon = self.localizedString.semicolon + c
			self.strings.append(self.localizedString)
			self.strings_d[self.localizedString.key] = self.localizedString
			self.localizedString = LocalizedString()
			self.engine = self.treat_idle_char
			return True
		return False
	
	def treat_value_escaped_char(self, c):
		self.localizedString.value = self.localizedString.value + u'\\' + c
		self.engine = self.treat_value_char
		return True
	
	def treat_value_char(self, c):
		if c == u'\\':  self.engine = self.treat_value_escaped_char
		elif c != u'"': self.localizedString.value = self.localizedString.value + c
		else:
			self.engine = self.treat_semicolon_char
		return True
	
	def treat_after_equal_between_char(self, c):
		if c == '"':
			self.engine = self.treat_value_char
			return True
		if c == u'\n' or c == u'\t' or c == u' ':
			self.localizedString.between = self.localizedString.between + c
			return True
		return False
	
	def treat_before_equal_between_char(self, c):
		if c == '=':
			self.engine = self.treat_after_equal_between_char
			self.localizedString.between = self.localizedString.between + c
			return True
		if c == u'\n' or c == u'\t' or c == u' ':
			self.localizedString.between = self.localizedString.between + c
			return True
		return False
	
	def treat_key_escaped_char(self, c):
		self.localizedString.key = self.localizedString.key + u'\\' + c
		self.engine = self.treat_key_char
		return True
	
	def treat_key_char(self, c):
		if c == u'\\':  self.engine = self.treat_key_escaped_char
		elif c == u'"': self.engine = self.treat_before_equal_between_char
		else:           self.localizedString.key = self.localizedString.key + c
		return True
	
	def treat_idle_char(self, c):
		if c == u'\n' or c == u'\t' or c == u' ':
			self.localizedString.comment = self.localizedString.comment + c
			return True
		elif c == u'/':
			self.localizedString.comment = self.localizedString.comment + c
			self.engine = self.confirm_comment_start
			return True
		elif c == u'"':
			self.engine = self.treat_key_char
			return True
		
		return False
	
	def read_from_file(self, fname):
		try:
			f = open(fname, encoding="utf_16", mode="r")
		except:
			print "Couldn't open file %s for reading." % fname
			return False
		
		self.strings = []
		self.strings_d = {}
		self.localizedString = LocalizedString()
		self.engine = self.treat_idle_char
		
		ok = True
		c = f.read(1)
		while c and ok:
			ok = self.engine(c)
			c = f.read(1)
		if not ok or self.engine != self.treat_idle_char:
			return False
		self.endOfFile = self.localizedString
		
		f.close()
		return True
	
	def save_to_file(self, fname):
		try:
			f = open(fname, encoding="utf_16", mode="w")
		except:
			print "Couldn't open file %s for writing." % fname
			return False
		
		for string in self.strings:
			f.write(string.__unicode__())
		
		f.close()
		return True
	
	def merge_with(self, new):
		merged = LocalizedFile()
		
		seen = []
		for string in self.strings:
			if not new.strings_d.has_key(string.key):
				print "*** Warning: Got unused key (consider removing): \"" + string.key + "\""
			
			seen.append(string.key)
			merged.strings.append(string)
			merged.strings_d[string.key] = string
		
		merged.strings.append(self.endOfFile)
		
		first = True
		for string in new.strings:
			if string.key in seen:
				continue
			
			first = False
			merged.strings.append(string)
			merged.strings_d[string.key] = string
		
		if (first): new.endOfFile.comment = new.endOfFile.comment.strip()
		merged.strings.append(new.endOfFile)
		
		return merged

def merge(merged_fname, old_fname, new_fname):
	old = LocalizedFile()
	new = LocalizedFile()
	if not old.read_from_file(old_fname): return 1
	if not new.read_from_file(new_fname): return 1
	merged = old.merge_with(new)
	if not merged.save_to_file(merged_fname): return 2


if __name__ == "__main__":
	if (len(sys.argv) != 4):
		print "Usage: " + sys.argv[0] + " old_filename new_filename merged_filename"
		print "       merged_filename can be equal to old_filename or new_filename"
		quit(42)
	
	quit(merge(sys.argv[3], sys.argv[1], sys.argv[2]))
