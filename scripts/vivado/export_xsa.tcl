# Recreate a carrier's block design and export a hardware handoff without a
# bitstream.
#
# vivado -mode batch -source export_xsa.tcl \
#     -tclargs <part> <board_part> <tool_version> <bd_tcl> <output.xsa>
#
# <bd_tcl> is carriers/<carrier>/bd/<carrier>.tcl, which creates the block
# design of the same name. The Vivado project is created next to the XSA,
# in vivado/. All paths must be absolute.
if {[llength $argv] != 5} {
    puts stderr "usage: -tclargs <part> <board_part> <tool_version> <bd_tcl> <output.xsa>"
    exit 1
}
lassign $argv part board_part tool_version bd_tcl xsa
set build_dir [file dirname $xsa]
set bd_name [file rootname [file tail $bd_tcl]]

if {[catch {
    # The generated design Tcl checks this too, but returns a status rather
    # than throwing an error. Fail explicitly before creating a project.
    if {![string match "${tool_version}*" [version -short]]} {
        error "This design requires Vivado $tool_version (running [version -short])."
    }

    create_project -force [file rootname [file tail $xsa]] [file join $build_dir vivado] -part $part
    set_property BOARD_PART $board_part [current_project]

    set result [source $bd_tcl]
    if {[string is integer -strict $result] && $result != 0} {
        error "$bd_tcl failed with status $result."
    }

    set bd_file [get_files -quiet */$bd_name.bd]
    if {[llength $bd_file] != 1} {
        error "Expected exactly one $bd_name.bd after sourcing $bd_tcl."
    }
    validate_bd_design
    save_bd_design
    generate_target all $bd_file
    add_files -norecurse [make_wrapper -files $bd_file -top]
    set_property top ${bd_name}_wrapper [current_fileset]
    update_compile_order -fileset sources_1

    # No -include_bit: this first handoff does not run synthesis/implementation.
    write_hw_platform -fixed -force -file $xsa
    close_project

    # The project now matches the Tcl; see export_bd.tcl.
    close [open [file join $build_dir vivado .bd-synced] w]
} message options]} {
    puts stderr "XSA export failed: $message"
    puts stderr [dict get $options -errorinfo]
    exit 1
}
exit 0
