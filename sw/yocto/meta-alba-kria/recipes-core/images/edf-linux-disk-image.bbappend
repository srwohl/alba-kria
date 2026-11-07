# make flash-emmc programs a gzip-compressed disk image (.wic.gz).
IMAGE_FSTYPES:append = " wic.gz"

# Login user, replacing EDF's amd-edf (empty password, expired on first
# login). Root stays locked; ALBA_USER gets sudo. Override both in
# conf/local.conf. Make the hash with: openssl passwd -6 '<password>'
# and write every $ in it as \$. The default password is "alba".
ALBA_USER ?= "alba"
ALBA_PASSWORD_HASH ?= "\$6\$albakria\$d3tYFcHRl4hImTo1Soja3muv0dO3wEust7Tz38eyTp7/kVFZDyZPbl2Y0bp3C7hxqMcQUkoCctOY2uB.itTG61"

# Groups as in EDF's amd-edf.conf
EXTRA_USERS_PARAMS = "\
    useradd -p '${ALBA_PASSWORD_HASH}' ${ALBA_USER}; \
    groupadd -r aie; \
    groupadd -r wayland; \
    usermod -a -G aie,audio,input,users,video,wayland ${ALBA_USER}; \
"
EXTRA_USERS_SUDOERS = "${ALBA_USER} ALL=(ALL) ALL;"
