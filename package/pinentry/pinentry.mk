################################################################################
#
# pinentry
#
################################################################################

PINENTRY_VERSION = 1.3.1
PINENTRY_SOURCE = pinentry-$(PINENTRY_VERSION).tar.bz2
PINENTRY_SITE = https://www.gnupg.org/ftp/gcrypt/pinentry
PINENTRY_LICENSE = GPL-2.0+
PINENTRY_LICENSE_FILES = COPYING
PINENTRY_DEPENDENCIES = \
	libassuan libgpg-error \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv) \
	host-pkgconf
PINENTRY_CONF_OPTS += \
	--with-libassuan-prefix=$(STAGING_DIR)/usr \
	--with-libgpg-error-prefix=$(STAGING_DIR)/usr \
	--without-libcap       # requires PAM

# Force the path to "gpgrt-config" (from the libgpg-error package) to
# avoid using the one on host, if present.
PINENTRY_CONF_ENV += GPGRT_CONFIG=$(STAGING_DIR)/usr/bin/gpgrt-config

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
PINENTRY_CONF_ENV += LIBS=-latomic
endif

ifeq ($(BR2_PACKAGE_LIBSECRET),y)
PINENTRY_CONF_OPTS += --enable-libsecret
PINENTRY_DEPENDENCIES += libsecret
else
PINENTRY_CONF_OPTS += --disable-libsecret
endif

# pinentry-efl backend
ifeq ($(BR2_PACKAGE_PINENTRY_EFL),y)
PINENTRY_CONF_OPTS += --enable-pinentry-efl
PINENTRY_DEPENDENCIES += efl
else
PINENTRY_CONF_OPTS += --disable-pinentry-efl
endif

# pinentry-fltk backend
ifeq ($(BR2_PACKAGE_PINENTRY_FLTK),y)
PINENTRY_CONF_ENV += ac_cv_path_FLTK_CONFIG=$(STAGING_DIR)/usr/bin/fltk-config
PINENTRY_CONF_OPTS += --enable-pinentry-fltk
PINENTRY_DEPENDENCIES += fltk
else
PINENTRY_CONF_OPTS += --disable-pinentry-fltk
endif

# pinentry-ncurses backend
ifeq ($(BR2_PACKAGE_PINENTRY_NCURSES),y)
PINENTRY_CONF_OPTS += --enable-ncurses --with-ncurses-include-dir=none
PINENTRY_DEPENDENCIES += ncurses
else
PINENTRY_CONF_OPTS += --disable-ncurses
endif

# pinentry-gtk2 backend
ifeq ($(BR2_PACKAGE_PINENTRY_GTK2),y)
PINENTRY_CONF_OPTS += --enable-pinentry-gtk2
PINENTRY_DEPENDENCIES += libgtk2
else
PINENTRY_CONF_OPTS += --disable-pinentry-gtk2
endif

# pinentry-qt5 backend
ifeq ($(BR2_PACKAGE_PINENTRY_QT5),y)
PINENTRY_CONF_OPTS += --enable-pinentry-qt
PINENTRY_DEPENDENCIES += qt5base
else
PINENTRY_CONF_OPTS += --disable-pinentry-qt
endif

$(eval $(autotools-package))
