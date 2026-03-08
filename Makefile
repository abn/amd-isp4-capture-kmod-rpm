NAME    := amd-isp4-capture-kmod
VERSION := $(shell rpm -q --specfile $(NAME).spec --queryformat '%{version}\n' 2>/dev/null | head -1)
TARBALL := $(NAME)-$(VERSION).tar.gz

CONTAINER_IMAGE := quay.io/abn/rpmbuilder:fedora-43

.PHONY: tgz rpm clean

tgz:
	tito build --test --tgz
	cp $$(ls -t /tmp/tito/$(NAME)-git-*.tar.gz | head -1) $(TARBALL)

rpm: tgz
	mkdir -p output
	podman run --rm \
	  -v $(CURDIR):/sources:z \
	  -v $(CURDIR)/output:/output:z \
	  $(CONTAINER_IMAGE) rpmbuilder

clean:
	rm -f $(NAME)-*.tar.gz
	rm -f output/*.rpm
