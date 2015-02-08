# Root AOSP source makefile
# su is built here 

LOCAL_PATH :=  $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := su
LOCAL_MODULE_TAGS := eng debug
LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_STATIC_LIBRARIES := libc libcutils
LOCAL_C_INCLUDES := external/sqlite/dist
LOCAL_SRC_FILES := Superuser/jni/su/su.c Superuser/jni/su/daemon.c Superuser/jni/su/activity.c Superuser/jni/su/db.c Superuser/jni/su/utils.c Superuser/jni/su/pts.c ../../sqlite/dist/sqlite3.c
LOCAL_CFLAGS := -DSQLITE_OMIT_LOAD_EXTENSION

ifdef SUPERUSER_EMBEDDED
LOCAL_CFLAGS += -DSUPERUSER_EMBEDDED
LOCAL_CFLAGS += -DREQUESTOR=\"com.spezi77.toolbox\"
LOCAL_CFLAGS += -DREQUESTOR_PREFIX=\"com.spezi77.toolbox.superuser\"
endif

LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
include $(BUILD_EXECUTABLE)


SYMLINKS := $(addprefix $(TARGET_OUT)/bin/,su)
$(SYMLINKS): $(LOCAL_MODULE)
$(SYMLINKS): $(LOCAL_INSTALLED_MODULE) $(LOCAL_PATH)/Android.mk
	@echo "Symlink: $@ -> /system/xbin/su"
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) ln -sf ../xbin/su $@

ALL_DEFAULT_INSTALLED_MODULES += $(SYMLINKS)
# We need this so that the installed files could be picked up based on the
# local module name
ALL_MODULES.$(LOCAL_MODULE).INSTALLED := \
    $(ALL_MODULES.$(LOCAL_MODULE).INSTALLED) $(SYMLINKS)
