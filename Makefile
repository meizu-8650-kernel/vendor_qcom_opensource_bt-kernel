KERNEL_SRC ?= /lib/modules/$(shell uname -r)/build
M ?= $(shell pwd)

BT_ROOT=$(KERNEL_SRC)/$(M)
AUDIO_ROOT=$(BT_ROOT)/../audio-kernel
KBUILD_OPTIONS += BT_ROOT=$(BT_ROOT)
KBUILD_OPTIONS += BOARD_PLATFORM=$(TARGET_BOARD_PLATFORM)
KBUILD_OPTIONS += CONFIG_BT_HW_SECURE_DISABLE=y
KBUILD_OPTIONS += CONFIG_MSM_BT_POWER=m
KBUILD_OPTIONS += CONFIG_BTFM_SLIM=m

ifneq ($(filter $(TARGET_BOARD_PLATFORM),pineapple volcano),)
KBUILD_OPTIONS += CONFIG_BTFM_CODEC=m
KBUILD_OPTIONS += CONFIG_BTFM_SWR=m
KBUILD_OPTIONS += CONFIG_I2C_RTC6226_QCA=m
endif
KBUILD_EXTRA_SYMBOLS := \
    $(OUT_DIR)/../sm8650-modules/qcom/opensource/securemsm-kernel/Module.symvers \
    $(OUT_DIR)/../sm8650-modules/qcom/opensource/wlan/platform/Module.symvers
ifneq ($(filter $(TARGET_BOARD_PLATFORM),pineapple volcano),)
KBUILD_OPTIONS += AUDIO_ROOT=$(AUDIO_ROOT)
KBUILD_EXTRA_SYMBOLS += $(OUT_DIR)/../sm8650-modules/qcom/opensource/audio-kernel/Module.symvers
endif
KBUILD_OPTIONS += KBUILD_EXTRA_SYMBOLS="$(KBUILD_EXTRA_SYMBOLS)"

all:
	$(MAKE) -C $(KERNEL_SRC) M=$(M) modules $(KBUILD_OPTIONS)

modules_install:
	$(MAKE) INSTALL_MOD_STRIP=1 -C $(KERNEL_SRC) M=$(M) modules_install

%:
	$(MAKE) -C $(KERNEL_SRC) M=$(M) $@ $(KBUILD_OPTIONS)

clean:
	$(MAKE) -C $(KERNEL_SRC) M=$(M) clean

