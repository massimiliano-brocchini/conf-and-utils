IDLC=/usr/lib/xulrunner-1.9.2/xpidl
INC=/usr/share/idl/xulrunner-1.9.2/
XPTS=TabLogger.xpt

all: $(XPTS)

%.xpt: %.idl
	$(IDLC) -m typelib -w -v -I $(INC) -e $(@) $(<)

.PHONY: all
