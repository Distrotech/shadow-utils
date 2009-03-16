all: rename_failure.so

rename_failure.so: rename_failure.c
	gcc -W -Wall -pedantic -g $< -shared -ldl -o $@
