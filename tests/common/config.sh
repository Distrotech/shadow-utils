# Generic functions to save, change, and restore configuration files

set -e


# Save the configuration files in tmp.
save_config ()
{
	[ ! -d tmp ] && mkdir tmp
	find config -depth -path "*/.svn/*" -prune -o -type f -print | sed -e 's/config\///' |
	while read file
	do
		mkdir -p "tmp/$(dirname "$file")"
		[ -f "/$file" ] && cp -dp "/$file" "tmp/$file" || true
	done
}

# Copy the config files from config to the system
change_config ()
{
	find config -depth -path "*/.svn/*" -prune -o -type f -print | sed -e 's/config\///' |
	while read file
	do
		cp -f "config/$file" "/$file"
	done
}

# Restored the config files in the system.
# The config files must be saved before with save_config ().
restore_config ()
{
	find config -depth -path "*/.svn/*" -prune -o -type f -print | sed -e 's/config\///' |
	while read file
	do
		if [ -f "tmp/$file" ]; then
			cp -dp "tmp/$file" "/$file"
			rm "tmp/$file"
		else
			rm "/$file"
		fi
		d="$(dirname "tmp/$file")"
		while [ -n "$d" ] && [ "$d" != "." ]
		do
			rmdir "$d" 2>/dev/null || true
			d="$(dirname "$d")"
		done
	done

	rmdir tmp 2>/dev/null || true
}

