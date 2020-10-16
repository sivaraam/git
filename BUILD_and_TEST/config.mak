DEVELOPER=1
DEVELOPERS=1
SANITIZE = address,leak
CFLAGS += -g -O2
CFLAGS += -ggdb3
CFLAGS += -fvar-tracking-assignments
CFLAGS += -fno-omit-frame-pointer 
CFLAGS += -DFLEX_ARRAY=2048

NO_GETTEXT=1
prefix=/home/$(USER)/.local
#CFLAGS += -Wno-unused-value
