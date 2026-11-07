# Write a carrier's block design back to carriers/<carrier>/bd/<bd_name>.tcl
# after editing it in the Vivado GUI. <bd_name> is the carrier name unless
# its carrier.mk sets BD_NAME.
#
# From make (batch, opens the saved project):
#   vivado -mode batch -source export_bd.tcl -tclargs <project.xpr> <bd_tcl>
# From the Vivado GUI Tcl console, with the carrier's project open:
#   source <repo>/scripts/vivado/export_bd.tcl
# Either way the design is validated and saved first, so in the GUI unsaved
# edits are included.
#
# The project is named after the carrier and holds one block design, so the
# output path follows from those names. All paths must be absolute.
set repo_dir [file normalize [file join [file dirname [info script]] .. ..]]

proc export_bd {repo_dir bd_tcl} {
    set bd_name [file rootname [file tail $bd_tcl]]
    set bd_file [get_files -quiet */$bd_name.bd]
    if {[llength $bd_file] != 1} {
        error "Expected exactly one $bd_name.bd in project [current_project]."
    }
    if {[current_bd_design -quiet] eq "" || [get_property NAME [current_bd_design]] ne $bd_name} {
        open_bd_design $bd_file
    }
    # Unvalidated designs export differently (no validate_bd_design call, plus
    # a warning) and may not rebuild; validation errors stop the export here.
    validate_bd_design
    save_bd_design
    write_bd_tcl -force $bd_tcl

    # Record that the project and the Tcl match. make xsa and make bd-export
    # compare against this to protect unexported GUI edits and newer Tcl.
    close [open [file join [get_property DIRECTORY [current_project]] .bd-synced] w]
    puts "Wrote $bd_tcl"
}

if {$::rdi::mode eq "gui"} {
    set carrier [get_property NAME [current_project]]
    set bd_files [get_files -quiet *.bd]
    if {[llength $bd_files] != 1} {
        error "Expected exactly one block design in project $carrier."
    }
    set bd_name [file rootname [file tail [lindex $bd_files 0]]]
    export_bd $repo_dir [file join $repo_dir carriers $carrier bd $bd_name.tcl]
    return
}

if {[llength $argv] != 2} {
    puts stderr "usage: -tclargs <project.xpr> <bd_tcl>"
    exit 1
}
lassign $argv xpr bd_tcl
if {[catch {
    open_project $xpr
    export_bd $repo_dir $bd_tcl
    close_project
} message options]} {
    puts stderr "Block design export failed: $message"
    puts stderr [dict get $options -errorinfo]
    exit 1
}
exit 0
