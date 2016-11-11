include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TinderPlusMinus
TinderPlusMinus_FILES = Tweak.xm
TinderPlusMinus_FRAMEWORKS = MediaPlayer
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
