# Project-wide settings shared by every carrier: tool and release versions.
# Part, board part and machine are per carrier: carriers/<name>/carrier.mk.
# (Keep comments on their own lines: Make would keep trailing spaces.)

# Vivado, SDTGen and gen-machine-conf must all match this release.
TOOL_VERSION := 2026.1
EDF_RELEASE  := amd-edf-rel-v26.06.1

# Carrier built when none is given: make CARRIER=<name> ...
CARRIER      ?= fim2
