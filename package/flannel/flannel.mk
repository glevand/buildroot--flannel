################################################################################
#
# flannel
#
################################################################################

FLANNEL_VERSION = 0.26.1
FLANNEL_SITE = $(call github,flannel-io,flannel,v$(FLANNEL_VERSION))

FLANNEL_LICENSE = Apache-2.0
FLANNEL_LICENSE_FILES = LICENSE

FLANNEL_LDFLAGS = -X github.com/flannel-io/flannel/version.Version=$(FLANNEL_VERSION)

# Upstream flannel only supports CGO on x86_64 (aka amd64):
#   https://github.com/flannel-io/flannel/issues/1988#issuecomment-2141483747
#   https://github.com/flannel-io/flannel/blob/v0.25.1/Makefile#L11
# So force it disabled for anything but x86_64, where we keep the default
ifeq ($(BR2_x86_64),)
FLANNEL_GO_ENV += CGO_ENABLED=0
endif

# Install flannel to its well known location.
define FLANNEL_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/flannel $(TARGET_DIR)/opt/bin/flanneld
	$(INSTALL) -D -m 0755 $(@D)/dist/mk-docker-opts.sh $(TARGET_DIR)/opt/bin/mk-docker-opts.sh
endef

$(eval $(golang-package))
