include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TinderPlusMinus
TinderPlusMinus_FILES = Tweak.xm
TinderPlusMinus_FRAMEWORKS = MediaPlayer AVFoundation
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
