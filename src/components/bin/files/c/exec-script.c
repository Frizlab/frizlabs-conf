#include <stdio.h>
#include <unistd.h>


/* Stringification */
# define _sharp(x) #x
# define S(x) _sharp(x)

int main(int argc, char **argv) {
	char *newargv[argc + 1/*the path to the script*/ + 1/*argv is NULL-terminated*/];
	newargv[0] = argv[0];
	newargv[1] = S(SCRIPT);
	for (int i = 1; i <= argc; ++i) {
		newargv[i + 1] = argv[i];
	}
	execve(S(INTERPRETER), newargv, NULL);
	fprintf(stderr, "error running execve\n");
	return 255;
}
