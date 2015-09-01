# Copyright 2007 The Android Open Source Project
#
# Copies files into the directory structure described by a manifest

# This tool is prebuilt if we're doing an app-only build.
ifeq ($(TARGET_BUILD_APPS)$(filter true,$(TARGET_BUILD_PDK)),)

LOCAL_PATH:= $(call my-dir)

# Logic shared between aidl and its unittests
include $(CLEAR_VARS)
LOCAL_MODULE := libaidl-common

LOCAL_CLANG_CFLAGS := -Wall -Werror
# Tragically, the code is riddled with unused parameters.
LOCAL_CLANG_CFLAGS += -Wno-unused-parameter
# yacc dumps a lot of code *just in case*.
LOCAL_CLANG_CFLAGS += -Wno-unused-function
LOCAL_CLANG_CFLAGS += -Wno-unneeded-internal-declaration
# yacc is a tool from a more civilized age.
LOCAL_CLANG_CFLAGS += -Wno-deprecated-register
# yacc also has a habit of using char* over const char*.
LOCAL_CLANG_CFLAGS += -Wno-writable-strings

LOCAL_SRC_FILES := \
    AST.cpp \
    Type.cpp \
    aidl.cpp \
    aidl_language.cpp \
    aidl_language_l.l \
    aidl_language_y.y \
    generate_java.cpp \
    generate_java_binder.cpp \
    generate_java_rpc.cpp \
    options.cpp \
    search_path.cpp \

include $(BUILD_HOST_STATIC_LIBRARY)


# aidl executable
include $(CLEAR_VARS)
LOCAL_MODULE := aidl

LOCAL_MODULE_HOST_OS := darwin linux windows
LOCAL_CFLAGS := -Wall -Werror
LOCAL_SRC_FILES := main.cpp
LOCAL_STATIC_LIBRARIES := libaidl-common
include $(BUILD_HOST_EXECUTABLE)


# Unit tests
include $(CLEAR_VARS)
LOCAL_MODULE := aidl_unittests

LOCAL_CFLAGS := -g -DUNIT_TEST -Wall -Werror
LOCAL_SRC_FILES := \
    options_unittest.cpp \
    tests/test.cpp \

LOCAL_STATIC_LIBRARIES := \
    libaidl-common \
    libgmock_host \
    libgtest_host \
    libBionicGtestMain
LOCAL_LDLIBS := -lrt
include $(BUILD_HOST_NATIVE_TEST)

endif # No TARGET_BUILD_APPS or TARGET_BUILD_PDK
