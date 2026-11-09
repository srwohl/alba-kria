# Load the generic UIO driver at boot. It is a module, and nothing else
# loads it: its generic-uio match comes from uio_pdrv_genirq.of_id on the
# kernel command line, so the module has no alias to autoload from. Without
# it the FIM2 and BRAM device-tree nodes get no /dev/uioN.
KERNEL_MODULE_AUTOLOAD += "uio_pdrv_genirq"
