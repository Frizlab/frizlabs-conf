#!/usr/bin/env python2
# Original script is probably from <https://stackoverflow.com/a/8101937> or
#  <http://www.iki.fi/fingon/iphonebackupdb.py> (from the same stackoverflow).
# A python3 version could be found here: <https://stackoverflow.com/a/32142655>.

import os
import sys
import shutil
import hashlib

mbdx = {}

def getint(data, offset, intsize):
	"""Retrieve an integer (big-endian) and new offset from the current offset"""
	value = 0
	while intsize > 0:
		value = (value<<8) + ord(data[offset])
		offset = offset + 1
		intsize = intsize - 1
	return value, offset

def getstring(data, offset):
	"""Retrieve a string and new offset from the current offset into the data"""
	if data[offset] == chr(0xFF) and data[offset+1] == chr(0xFF):
		return '', offset+2 # Blank string
	length, offset = getint(data, offset, 2) # 2-byte length
	value = data[offset:offset+length]
	return value, (offset + length)

def process_mbdb_file(filename):
	mbdb = {} # Map offset of info in this file => file info
	data = open(filename).read()
	if data[0:4] != "mbdb":
		raise Exception("This does not look like an MBDB file")
	offset = 4
	offset = offset + 2 # Value x05 x00, not sure what this is
	while offset < len(data):
		fileinfo = {}
		fileinfo['start_offset'] = offset
		fileinfo['domain'], offset = getstring(data, offset)
		fileinfo['filename'], offset = getstring(data, offset)
		fileinfo['linktarget'], offset = getstring(data, offset)
		fileinfo['datahash'], offset = getstring(data, offset)
		fileinfo['unknown1'], offset = getstring(data, offset)
		fileinfo['mode'], offset = getint(data, offset, 2)
		fileinfo['unknown2'], offset = getint(data, offset, 4)
		fileinfo['unknown3'], offset = getint(data, offset, 4)
		fileinfo['userid'], offset = getint(data, offset, 4)
		fileinfo['groupid'], offset = getint(data, offset, 4)
		fileinfo['mtime'], offset = getint(data, offset, 4)
		fileinfo['atime'], offset = getint(data, offset, 4)
		fileinfo['ctime'], offset = getint(data, offset, 4)
		fileinfo['filelen'], offset = getint(data, offset, 8)
		fileinfo['flag'], offset = getint(data, offset, 1)
		fileinfo['numprops'], offset = getint(data, offset, 1)
		fileinfo['properties'] = {}
		for ii in range(fileinfo['numprops']):
			propname, offset = getstring(data, offset)
			propval, offset = getstring(data, offset)
			fileinfo['properties'][propname] = propval
		mbdb[fileinfo['start_offset']] = fileinfo
		fullpath = fileinfo['domain'] + '-' + fileinfo['filename']
		file_id = hashlib.sha1(fullpath)
		mbdx[fileinfo['start_offset']] = file_id.hexdigest()
	return mbdb

def modestr(val):
	def mode(val):
		if (val & 0x4): r = 'r'
		else: r = '-'
		if (val & 0x2): w = 'w'
		else: w = '-'
		if (val & 0x1): x = 'x'
		else: x = '-'
		return r+w+x
	return mode(val>>6) + mode(val>>3) + mode(val)

def fileinfo_str(f, verbose=False):
	if not verbose: return "(%s)%s::%s" % (f['fileID'], f['domain'], f['filename'])
	if (f['mode'] & 0xE000) == 0xA000: type = 'l' # symlink
	elif (f['mode'] & 0xE000) == 0x8000: type = '-' # file
	elif (f['mode'] & 0xE000) == 0x4000: type = 'd' # dir
	else:
		print >> sys.stderr, "Unknown file type %04x for %s" % (f['mode'], fileinfo_str(f, False))
		type = '?' # unknown
	info = ("%s%s %08x %08x %7d %10d %10d %10d (%s)%s::%s" % (type, modestr(f['mode']&0x0FFF), f['userid'], f['groupid'], f['filelen'], f['mtime'], f['atime'], f['ctime'], f['fileID'], f['domain'], f['filename']))
	if type == 'l': info = info + ' -> ' + f['linktarget'] # symlink destination
	for name, value in f['properties'].items(): # extra properties
		info = info + ' ' + name + '=' + repr(value)
	return info

#####
def treat_file(f, outdir):
	print "Treating file", f['domain'], "--", f['filename']
	treated_file = outdir + os.sep + f['domain'] + os.sep + f['filename']
	if (f['mode'] & 0xE000) == 0x4000:
		# Treating a dir
		os.mkdir(treated_file)
	elif (f['mode'] & 0xE000) == 0xA000:
		# Treating a link
		os.symlink(f['linktarget'], treated_file)
	elif (f['mode'] & 0xE000) == 0x8000:
		# Treating a file
		if os.path.lexists(f['fileID']): shutil.copy(f['fileID'], treated_file)
		else: print >> sys.stderr, "Warning: File with id", f['fileID'], "was not found (output would have been", treated_file + ")"
	else:
		print >> sys.stderr, "Unknown file type %04x for %s" % (f['mode'], fileinfo_str(f, False))
		return False

	# TODO: Support mtime, atime, ctime? (ctime seems not to be possible), userid?, groupid?, mode?

	return True

#####
def usage(fp, progname):
	print >> fp, "Usage:", progname, "[-o outdir] backupdir"
	print >> fp, "Warning: outdir is relative to backupdir"

#####
verbose = False
if __name__ == '__main__':
	if len(sys.argv) != 2 and (len(sys.argv) != 4 or sys.argv[1] != "-o"):
		usage(sys.stderr, sys.argv[0])
		quit(21)

	base_dir = sys.argv[1] if len(sys.argv) == 2 else sys.argv[3]
	out_dir = "../ios_backup_to_files_output" if len(sys.argv) == 2 else sys.argv[2].rstrip('/')
	try:
		os.chdir(base_dir)
	except Exception, err:
		print >> sys.stderr, "Cannot cd to", base_dir + ". Got error", str(err)
		quit(42)

	if os.path.lexists(out_dir):
		try: os.rmdir(out_dir)
		except:
			print >> sys.stderr, "Cannot use", out_dir, "as output dir. It already exist."
			quit (12)
	os.mkdir(out_dir)

	mbdb = process_mbdb_file("Manifest.mbdb")
	fileinfos = mbdb.items()
	# Sorts fileinfos by filename length. Avoid problems when creating directories
	fileinfos.sort(lambda x, y: cmp(len(x[1]['filename']), len(y[1]['filename'])))
	for offset, fileinfo in fileinfos:
		if offset in mbdx:
			fileinfo['fileID'] = mbdx[offset]
		else:
			fileinfo['fileID'] = "<nofileID>"
			print >> sys.stderr, "No fileID found for %s" % fileinfo_str(fileinfo)
		treat_file(fileinfo, out_dir)
#		print fileinfo_str(fileinfo, verbose)
