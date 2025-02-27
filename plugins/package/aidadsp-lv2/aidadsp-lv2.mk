######################################
#
# aidadsp-lv2
#
######################################

AIDADSP_LV2_VERSION = a70048ddedcf3bfaebf0bfe0940f05f30b845031
AIDADSP_LV2_SITE = https://github.com/AidaDSP/aidadsp-lv2.git
AIDADSP_LV2_SITE_METHOD = git
AIDADSP_LV2_BUNDLES = rt-neural-generic.lv2

# prepare custom build flags
AIDADSP_LV2_TARGET_CFLAGS = $(TARGET_CFLAGS)
AIDADSP_LV2_TARGET_CXXFLAGS = $(TARGET_CXXFLAGS) -std=gnu++17
AIDADSP_LV2_TARGET_OPTIMIZATION = -fPIC $(filter-out -funsafe-loop-optimizations,$(subst ",,$(BR2_TARGET_OPTIMIZATION)))

# can't use -funsafe-loop-optimizations
AIDADSP_LV2_TARGET_CFLAGS += $(AIDADSP_LV2_TARGET_OPTIMIZATION)
AIDADSP_LV2_TARGET_CXXFLAGS += $(AIDADSP_LV2_TARGET_OPTIMIZATION)

# LTO-specific flags (must be present on build and link stage)
AIDADSP_LV2_LTO_FLAGS = -fno-strict-aliasing -flto -ffat-lto-objects

# pass options into cmake
AIDADSP_LV2_CONF_OPTS = -DPREFIX="/usr/lib/lv2"
# AIDADSP_LV2_CONF_OPTS += -DRTNEURAL_XSIMD=ON
AIDADSP_LV2_CONF_OPTS += -DRTNEURAL_EIGEN=ON
AIDADSP_LV2_CONF_OPTS += -DCMAKE_C_FLAGS_RELEASE="$(AIDADSP_LV2_TARGET_CFLAGS) $(AIDADSP_LV2_LTO_FLAGS)"
AIDADSP_LV2_CONF_OPTS += -DCMAKE_CXX_FLAGS_RELEASE="$(AIDADSP_LV2_TARGET_CXXFLAGS) $(AIDADSP_LV2_LTO_FLAGS)"
AIDADSP_LV2_CONF_OPTS += -DCMAKE_SHARED_LINKER_FLAGS_RELEASE="$(TARGET_LDFLAGS) $(AIDADSP_LV2_LTO_FLAGS)"

# needed for submodules support
AIDADSP_LV2_PRE_DOWNLOAD_HOOKS += MOD_PLUGIN_BUILDER_DOWNLOAD_WITH_SUBMODULES

$(eval $(cmake-package))
