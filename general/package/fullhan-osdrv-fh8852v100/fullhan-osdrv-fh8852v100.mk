################################################################################
#
# fullhan-osdrv-fh8852v100
#
################################################################################

FULLHAN_OSDRV_FH8852V100_VERSION =
FULLHAN_OSDRV_FH8852V100_SITE =
FULLHAN_OSDRV_FH8852V100_LICENSE = MIT
FULLHAN_OSDRV_FH8852V100_LICENSE_FILES = LICENSE

# Vendor SDK blobs (libdsp/libisp/*.ko/firmware) and the sensor ISP tuning under
# sensor/params/ come from the Fullhan FH8852/FH8856 OSDRV V1.2.0 release (build
# 2020-03-24); they are not generated in this tree. This is the sanctioned
# <vendor>-osdrv-<family> home for them. Per-device tuning and the divinus
# configuration for a specific retail camera belong in OpenIPC/builder.
define FULLHAN_OSDRV_FH8852V100_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -d $(TARGET_DIR)/lib/firmware
	$(INSTALL) -m 644 -t $(TARGET_DIR)/lib/firmware $(FULLHAN_OSDRV_FH8852V100_PKGDIR)/files/firmware/*

	$(INSTALL) -m 755 -d $(TARGET_DIR)/lib/modules/3.0.8/fullhan
	$(INSTALL) -m 644 -t $(TARGET_DIR)/lib/modules/3.0.8/fullhan $(FULLHAN_OSDRV_FH8852V100_PKGDIR)/files/kmod/*.ko

	$(INSTALL) -m 755 -d $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 755 -t $(TARGET_DIR)/usr/bin $(FULLHAN_OSDRV_FH8852V100_PKGDIR)/files/script/load*

	# netlink dumps oops the 3.0.8 kernel; shadow busybox ip with a /proc based wrapper
	$(INSTALL) -m 755 $(FULLHAN_OSDRV_FH8852V100_PKGDIR)/files/script/ip $(TARGET_DIR)/sbin/ip

	$(INSTALL) -m 755 -d $(TARGET_DIR)/usr/lib
	$(INSTALL) -m 644 -t $(TARGET_DIR)/usr/lib/ $(FULLHAN_OSDRV_FH8852V100_PKGDIR)/files/lib/*.so

	$(INSTALL) -m 755 -d $(TARGET_DIR)/usr/lib/sensors
	$(INSTALL) -m 644 -t $(TARGET_DIR)/usr/lib/sensors $(FULLHAN_OSDRV_FH8852V100_PKGDIR)/files/sensor/*.so

	$(INSTALL) -m 755 -d $(TARGET_DIR)/usr/lib/sensors/params
	$(INSTALL) -m 644 -t $(TARGET_DIR)/usr/lib/sensors/params $(FULLHAN_OSDRV_FH8852V100_PKGDIR)/files/sensor/params/*

	# divinus config and init script only when divinus is in the image (not general/overlay,
	# which would ship to every board and force a full CI rebuild)
	# The init script ships with the family; /etc/divinus.yaml is per device and
	# comes from an OpenIPC/builder overlay -- S95divinus exits quietly without it.
	$(if $(BR2_PACKAGE_DIVINUS), \
		$(INSTALL) -m 755 -D $(FULLHAN_OSDRV_FH8852V100_PKGDIR)/files/script/S95divinus $(TARGET_DIR)/etc/init.d/S95divinus)
endef

$(eval $(generic-package))
