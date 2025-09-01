PROJECT_ROOT := $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/..)

ifeq ($(strip $(PROJECT_ROOT)),)
$(error PROJECT_ROOT is not set - stopping to prevent destructive actions )
endif
