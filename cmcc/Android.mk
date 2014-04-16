LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE    := megjb
LOCAL_SRC_FILES := libmegjb.so
include $(PREBUILT_SHARED_LIBRARY)
