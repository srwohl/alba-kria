# Optional static address for the main Ethernet port. By default every wired
# port uses DHCP (poky's 80-wired.network). Set ALBA_STATIC_ADDRESS in
# conf/local.conf to give ALBA_NET_IFACE a fixed address instead, e.g.
#   ALBA_STATIC_ADDRESS = "192.168.1.10/24"
#   ALBA_STATIC_GATEWAY = "192.168.1.1"
#   ALBA_STATIC_DNS = "192.168.1.1"
# On a running board, edit /etc/systemd/network/10-static.network instead.
#
# end0 is the ethernet0 alias (GEM0 on FIM2 and KR260), named by systemd.
ALBA_NET_IFACE ?= "end0"
ALBA_STATIC_ADDRESS ?= ""
ALBA_STATIC_GATEWAY ?= ""
# Space-separated list
ALBA_STATIC_DNS ?= ""

do_install:append() {
    [ -n "${ALBA_STATIC_ADDRESS}" ] || return 0
    f=${D}${sysconfdir}/systemd/network/10-static.network
    install -d $(dirname $f)
    printf '[Match]\nName=%s\n\n[Network]\nAddress=%s\n' \
        "${ALBA_NET_IFACE}" "${ALBA_STATIC_ADDRESS}" > $f
    [ -z "${ALBA_STATIC_GATEWAY}" ] || printf 'Gateway=%s\n' "${ALBA_STATIC_GATEWAY}" >> $f
    for dns in ${ALBA_STATIC_DNS}; do
        printf 'DNS=%s\n' "$dns" >> $f
    done
    chmod 0644 $f
}

FILES:${PN} += "${sysconfdir}/systemd/network/"
