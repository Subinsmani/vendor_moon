PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Disable excessive dalvik debug messages
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.debug.alloc=0

# Backup tool
PRODUCT_COPY_FILES += \
    vendor/moon/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/moon/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/moon/prebuilt/common/bin/50-moon.sh:system/addon.d/50-moon.sh \
    vendor/moon/prebuilt/common/bin/clean_cache.sh:system/bin/clean_cache.sh

# Backup services whitelist
PRODUCT_COPY_FILES += \
    vendor/moon/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/moon/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# aosmp-specific init file
PRODUCT_COPY_FILES += \
    vendor/moon/prebuilt/common/etc/init.local.rc:root/init.moon.rc

# Copy LatinIME for gesture typing
PRODUCT_COPY_FILES += \
    vendor/moon/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/moon/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/moon/prebuilt/common/etc/mkshrc:system/etc/mkshrc \
    vendor/moon/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf

# Fix Dialer
PRODUCT_COPY_FILES +=  \
    vendor/moon/prebuilt/common/sysconfig/dialer_experience.xml:system/etc/sysconfig/dialer_experience.xml

# Gzosp-specific startup services
PRODUCT_COPY_FILES += \
    vendor/moon/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/moon/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/moon/prebuilt/common/bin/sysinit:system/bin/sysinit

# Required packages
PRODUCT_PACKAGES += \
    CellBroadcastReceiver \
    Development \
    SpareParts \
    LockClock \
    GMsg \
    GContacts \
    GDialer \
    GClock \
    Retro \
    Via

# Optional packages
PRODUCT_PACKAGES += \
    Basic \
    LiveWallpapersPicker \
    PhaseBeam

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# MusicFX
ifeq ($(WITH_MUSICFX),true)
PRODUCT_PACKAGES += \
    MusicFX \
    audio_effects.conf \
    libcyanogen-dsp
else
$(warning MusicFX is undefined, please use 'WITH_MUSICFX := true' to make a build with MusicFX.' NOTE:remove audio_effects.conf from device tree')
endif


# Extra Optional packages
PRODUCT_PACKAGES += \
    Calculator \
    LatinIME \
    BluetoothExt


# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    fsck.exfat \
    mkfs.exfat \
    ntfsfix \
    ntfs-3g


PRODUCT_PACKAGES += \
    charger_res_images

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# Storage manager
PRODUCT_PROPERTY_OVERRIDES += \
    ro.storage_manager.enabled=true

# easy way to extend to add more packages
-include vendor/extra/product.mk

PRODUCT_PACKAGES += \
    AndroidDarkThemeOverlay \
    SettingsDarkThemeOverlay

PRODUCT_PACKAGE_OVERLAYS += vendor/moon/overlay/common

# Boot animation include
$(call inherit-product, vendor/moon/config/bootanimation.mk)

# Versioning System
# mosp first version.
MOON_VERSION_NUMBER := v1.0
MOON_VERSION_NAME  := 1.0 - Popsicle

MOON_DEVICE := $(MOON_BUILD)

ifndef MOON_BUILD_TYPE
    MOON_BUILD_TYPE := UNOFFICIAL
    
PRODUCT_PROPERTY_OVERRIDES += \
    ro.moon.buildtype=unofficial
endif

ifeq ($(MOON_BUILD_TYPE), OFFICIAL)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.moon.buildtype=official
endif

ifeq ($(MOON_BUILD_TYPE), ALPHA)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.moon.buildtype=alpha
endif

# Set all versions
MOON_VERSION := MoonOS_$(MOON_DEVICE)-$(shell date +"%Y%m%d")-$(MOON_VERSION_NUMBER)-$(MOON_BUILD_TYPE)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    moon.ota.version=$(MOON_VERSION) \
    ro.moon.version=$(MOON_VERSION) \
    ro.moon.version.name=$(MOON_VERSION_NAME)

# Google sounds
include vendor/moon/google/GoogleAudio.mk

EXTENDED_POST_PROCESS_PROPS := vendor/moon/tools/moon_process_props.py

