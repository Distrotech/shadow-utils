PKG=shadow
SITE=ftp://pkg-shadow.alioth.debian.org/pub/pkg-shadow/

deb:: check_cheese

include /usr/share/quilt/quilt.debbuild.mk

check_cheese:
	@dpkg-parsechangelog | grep -q "\* The \".*\".* release\." || { \
		echo ""; \
		echo " **                                  **"; \
		echo " **  Warning: not a cheesy release!  **"; \
		echo " **                                  **"; \
		echo ""; \
		exit 1; \
	}
