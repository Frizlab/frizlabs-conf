#define NDEBUG
#undef NDEBUG
#define NDEBUG

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/errno.h>
#include <sys/param.h>
#include <unistd.h>


/* Stringification */
#define _sharp(x) #x
#define S(x) _sharp(x)

#define STATIC_ASSERT(test, msg) typedef char _static_assert_##msg[((test)? 1: -1)]

#ifndef INTERPRETER_ARGS
# define INTERPRETER_ARGS "/bin/sh",NULL
#endif


int fatal(const char *errmsg) {
	fprintf(stderr, "%s\n", errmsg);
	return 255;
}

int fatal_perror(const char *errmsg) {
	perror(errmsg);
	return 255;
}


/* outputPath must be a buffer of at min MAXPATHLEN bytes. */
int getTempFile(char *outputPath) {
	const char *template = "exec-script.XXXXXX";
	const char *tmpdir = getenv("TMPDIR") ?: "/tmp";
	
	const size_t tmpdirlen = strlen(tmpdir);
	const size_t templatelen = strlen(template);
	int needsSlash = (tmpdirlen == 0 || tmpdir[tmpdirlen-1] != '/');
	if (tmpdirlen + (needsSlash ? 1 : 0) + templatelen >= MAXPATHLEN) {
		errno = ENAMETOOLONG;
		return -1;
	}
	
	int delta = 0;
	stpncpy(outputPath + delta, tmpdir, MAXPATHLEN - delta);
	delta += tmpdirlen;
	if (needsSlash) {
		stpncpy(outputPath + delta, "/", MAXPATHLEN - delta);
		delta += 1;
	}
	stpncpy(outputPath + delta, template, MAXPATHLEN - delta);
	delta += templatelen;
	assert(delta < MAXPATHLEN);
	
	/* mkstemps with a suffixlen set to 0 is the same as mkstemp AFAICT.
	 * I had the idea to put the original file extension in the temp file, but I did not do it. */
	int fd = mkstemps(outputPath, 0);
	if (fd == -1) return -1;
	if (unlink(outputPath) != 0)
		perror("warning: cannot delete temp file");
	
	int s = snprintf(outputPath, MAXPATHLEN, "/dev/fd/%d", fd);
	if (s < 0 || s >= MAXPATHLEN) {
		errno = ENAMETOOLONG;
		return -1;
	}
	
	return fd;
}


int main(int argc, char **argv) {
	const char *script = SCRIPT;
	const size_t scriptlen = strlen(script);
	
	/* Get a temporary file to write the script to. */
	int tmpfd = -1;
	char tmpfile[MAXPATHLEN];
	if ((tmpfd = getTempFile(tmpfile)) == -1)
		return fatal_perror("cannot get temp file");
	/* Write the script to the temporary file. */
	int c = -1, delta = 0;
	while ((c = write(tmpfd, script + delta, scriptlen - delta)) > 0)
		delta += c;
	if (c == -1)
		return fatal_perror("cannot write script contents to temp file");
	/* Seek the fd to the beginning of the file.
	 * The interpreter will be given this fd to read the temporary file (/dev/fd/n). */
	if (lseek(tmpfd, 0, SEEK_SET) == -1)
		return fatal_perror("cannot seek to the beginning of the temp file");
	
	char *interpreterArgs[] = {INTERPRETER_ARGS};
	STATIC_ASSERT(sizeof(interpreterArgs)/sizeof(char**) - 1 > 0, empty_interpreter_args);
	
	const size_t nInterpreterArgs = sizeof(interpreterArgs)/sizeof(char**) - 1;
	char *newargv[nInterpreterArgs + 1/*tempfile*/ + argc + 1/*argv is NULL-terminated*/];
	
	size_t i = 0;
	/* First arg ($0) is our $0. */
	newargv[i++] = argv[0];
	/* Then we add the interpreter’s args. */
	for (char **curInterpreterArg = interpreterArgs + 1; *curInterpreterArg != NULL; ++curInterpreterArg) {
		newargv[i++] = *curInterpreterArg;
	}
	/* We have written the script to tmpfile; it will be the interpreter source. */
	newargv[i++] = tmpfile;
	/* Add original arguments with which this program was called and the terminating NULL. */
	for (int j = 1; j <= argc; ++j) {
		newargv[i++] = argv[j];
	}
	
#ifndef NDEBUG
	fprintf(stderr, "Original script path at compilation time: '%s'\n", S(SCRIPT_PATH));
	fprintf(stderr, "Script sent to interpreter:\n---\n%s\n---\n", script);
	fprintf(stderr, "Launching: '%s'", interpreterArgs[0]);
	for (char **curarg = newargv; *curarg != NULL; ++ curarg) {
		fprintf(stderr, " '%s'", *curarg);
	}
	fprintf(stderr, "\n");
#endif
	
	execv(interpreterArgs[0], newargv);
	return fatal_perror("error running execv");
}
