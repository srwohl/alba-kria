# Recreate a carrier's block design and export a hardware handoff without a
# bitstream (make bit builds that from the same project).
#
# vivado -mode batch -source export_xsa.tcl \
#     -tclargs <part> <board_part> <tool_version> <bd_tcl> <output.xsa> <top> [source ...]
#
# <bd_tcl> is carriers/<carrier>/bd/<bd_name>.tcl, which creates the block
# design of the same name. <top> is the carrier's hand-written top level, or
# "" to use the block design's generated wrapper. Sources ending in .xdc are
# constraints; the rest are HDL. The Vivado project is created next to the
# XSA, in vivado/. All paths must be absolute.
if {[llength $argv] < 6} {
    puts stderr "usage: -tclargs <part> <board_part> <tool_version> <bd_tcl> <output.xsa> <top> \[source ...\]"
    exit 1
}
lassign $argv part board_part tool_version bd_tcl xsa top
set hdl_sources {}
set xdc_sources {}
foreach source [lrange $argv 6 end] {
    if {![file isfile $source]} {
        puts stderr "Source does not exist: $source"
        exit 1
    }
    if {[file extension $source] eq ".xdc"} {
        lappend xdc_sources $source
    } else {
        lappend hdl_sources $source
    }
}
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
    set_property source_mgmt_mode All [current_project]

    # Module references must be available before the block design is sourced.
    # Keep the original files in git as project sources; do not import copies
    # into the disposable build directory.
    if {[llength $hdl_sources] != 0} {
        add_files -norecurse $hdl_sources
        update_compile_order -fileset sources_1
    }
    if {[llength $xdc_sources] != 0} {
        add_files -fileset constrs_1 -norecurse $xdc_sources
    }

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
    if {$top eq ""} {
        add_files -norecurse [make_wrapper -files $bd_file -top]
        set top ${bd_name}_wrapper
    }
    set_property top $top [current_fileset]
    update_compile_order -fileset sources_1

    # No -include_bit: the bitstream is built and loaded separately (make bit).
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
