#include <stdio.h>
#include <unistd.h>


/* Stringification */
#define _sharp(x) #x
#define S(x) _sharp(x)

#define STATIC_ASSERT(test, msg) typedef char _static_assert_##msg[((test)? 1: -1)]

#ifndef INTERPRETER_ARGS
# define INTERPRETER_ARGS "/bin/sh",NULL
#endif

int main(int argc, char **argv) {
	char *interpreterArgs[] = {INTERPRETER_ARGS};
	STATIC_ASSERT(sizeof(interpreterArgs)/sizeof(char**) - 1 > 0, empty_interpreter_args);
	
	const size_t nInterpreterArgs = sizeof(interpreterArgs)/sizeof(char**) - 1;
	char *newargv[nInterpreterArgs + 1/*/dev/stdin*/ + argc + 1/*argv is NULL-terminated*/];
	
	size_t i = 0;
	/* First arg ($0) is our $0. */
	newargv[i++] = argv[0];
	/* Then we add the interpreter’s args. */
	for (char **curInterpreterArg = interpreterArgs + 1; *curInterpreterArg != NULL; ++curInterpreterArg) {
		newargv[i++] = *curInterpreterArg;
	}
	/* What will we execute? In our case, we send the script via stdin. */
	newargv[i++] = "/dev/stdin";
	/* Add original arguments with which this program was called and the terminating NULL. */
	for (int j = 1; j <= argc; ++j) {
		newargv[i++] = argv[j];
	}
	
	if (1) {
		fprintf(stderr, "Original script path at compilation time: '%s'\n", S(SCRIPT_PATH));
		fprintf(stderr, "Launching: '%s'", interpreterArgs[0]);
		for (char **curarg = newargv; *curarg != NULL; ++ curarg) {
			fprintf(stderr, " '%s'", *curarg);
		}
		fprintf(stderr, "\n");
	}
	
	execve(interpreterArgs[0], newargv, NULL);
	fprintf(stderr, "error running execve\n");
	return 255;
}
