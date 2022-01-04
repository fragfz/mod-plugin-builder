######################################
#
# harmonicexciter
#
######################################


HARMONICEXCITER_VERSION = 15df149110d789c2b077450337c31f761b0d97c9
HARMONICEXCITER_SITE = $(call github,brummer10,HarmonicExciter,$(HARMONICEXCITER_VERSION))
HARMONICEXCITER_BUNDLES = Harmonic_Exciter.lv2

ifdef BR2_cortex_a7
HARMONICEXCITER_SSE_CFLAGS = -mfpu=vfpv3
endif

HARMONICEXCITER_TARGET_MAKE = $(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) SSE_CFLAGS="$(HARMONICEXCITER_SSE_CFLAGS)" -C $(@D)

define HARMONICEXCITER_BUILD_CMDS
	$(HARMONICEXCITER_TARGET_MAKE) mod
endef

define HARMONICEXCITER_INSTALL_TARGET_CMDS
	$(HARMONICEXCITER_TARGET_MAKE) install DESTDIR=$(TARGET_DIR) INSTALL_DIR=/usr/lib/lv2
endef

$(eval $(generic-package))
