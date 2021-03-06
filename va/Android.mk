# Copyright (c) 2007 Intel Corporation. All Rights Reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sub license, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice (including the
# next paragraph) shall be included in all copies or substantial portions
# of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT.
# IN NO EVENT SHALL PRECISION INSIGHT AND/OR ITS SUPPLIERS BE LIABLE FOR
# ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# For libva
# =====================================================

LOCAL_PATH:= $(call my-dir)

ifeq ($(ENABLE_IMG_GRAPHICS),true)

LIBVA_DRIVERS_PATH = /system/lib

# Clang does not like partially initialized structures
# in va_fool.c, va.c and va_drm_utils.c.

include $(CLEAR_VARS)

LOCAL_MODULE := libva
LOCAL_MODULE_CLASS := SHARED_LIBRARIES

generated_sources_dir := $(call local-generated-sources-dir)

LOCAL_SRC_FILES := \
	va.c \
	va_trace.c \
	va_fool.c

LOCAL_CLANG_CFLAGS += -Wno-missing-field-initializers

LOCAL_CFLAGS := \
	-DANDROID \
	-DVA_DRIVERS_PATH="\"$(LIBVA_DRIVERS_PATH)\"" \
	-DLOG_TAG=\"libva\" \
	-DANDROID_ALOG

LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)/.. $(generated_sources_dir)

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/x11 \
	$(LOCAL_PATH)/..

LOCAL_CFLAGS += -Werror

LOCAL_SHARED_LIBRARIES := libdl libdrm libcutils liblog

LOCAL_HEADER_LIBRARIES := intel_libva_headers

include $(BUILD_SHARED_LIBRARY)

# For libva-android
# =====================================================

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	android/va_android.cpp \
	drm/va_drm_utils.c

LOCAL_CFLAGS := \
	-DANDROID -DLOG_TAG=\"libva-android\"

LOCAL_CLANG_CFLAGS += -Wno-missing-field-initializers

LOCAL_C_INCLUDES := \
	$(TARGET_OUT_HEADERS)/libdrm \
	$(LOCAL_PATH)/drm

LOCAL_CFLAGS += -Werror
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libva-android

LOCAL_HEADER_LIBRARIES := intel_libva_headers
LOCAL_SHARED_LIBRARIES := libva libdrm libnativewindow

include $(BUILD_SHARED_LIBRARY)


# For libva-egl
# =====================================================

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	egl/va_egl.c

LOCAL_CFLAGS := \
	-DANDROID -DLOG_TAG=\"libva-egl\"

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/x11

LOCAL_HEADER_LIBRARIES := intel_libva_headers
LOCAL_CFLAGS += -Werror
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libva-egl

LOCAL_SHARED_LIBRARIES := libva

include $(BUILD_SHARED_LIBRARY)


# For libva-tpi
# =====================================================

include $(CLEAR_VARS)

LOCAL_CLANG_CFLAGS += -Wno-missing-field-initializers

LOCAL_SRC_FILES := va_tpi.c

LOCAL_CFLAGS := -DANDROID -DLOG_TAG=\"libva-tpi\"

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/..

LOCAL_HEADER_LIBRARIES := intel_libva_headers
LOCAL_SHARED_LIBRARIES := libva
LOCAL_CFLAGS += -Werror
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libva-tpi

include $(BUILD_SHARED_LIBRARY)

endif # $(ENABLE_IMG_GRAPHICS),true)
