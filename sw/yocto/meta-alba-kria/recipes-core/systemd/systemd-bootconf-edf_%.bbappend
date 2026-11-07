# Kernel command line of the systemd-boot entry on the disk image (EFI boot).
# It replaces the device tree's /chosen/bootargs, so carry its console and
# clk_ignore_unused over, plus what the DisplayPort output needs:
#   console=tty1        kernel messages on DisplayPort as well; the last
#                       console= (serial) stays /dev/console
#   clk_ignore_unused   keep clocks set up by the boot firmware running
#   cma=900M            contiguous memory for DisplayPort/GPU/VCU buffers,
#                       as in AMD's Kria images (the kernel default is 256M)
ALBA_KERNEL_CMDLINE ?= "earlycon console=tty1 console=ttyPS0,115200 clk_ignore_unused cma=900M"
KERNEL_CMDLINE_EXTRA = "${ALBA_KERNEL_CMDLINE} uio_pdrv_genirq.of_id=generic-uio"
