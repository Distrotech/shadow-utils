all: rename_failure.so rmdir_failure.so unlink_failure.so

%.so: %.c
	gcc -W -Wall -pedantic -g $< -shared -ldl -o $@
