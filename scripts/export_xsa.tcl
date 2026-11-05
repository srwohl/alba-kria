# Recreate the block design and export a hardware handoff without a bitstream.
# Invoked by Make from build/; all paths are resolved from this script.
set repo_dir [file dirname [file dirname [file normalize [info script]]]]
set build_dir [file join $repo_dir build]

if {[catch {
    file mkdir $build_dir
    cd $build_dir

    # The generated design Tcl checks this too, but returns a status rather
    # than throwing an error. Fail explicitly before creating a project.
    if {![string match "2026.1*" [version -short]]} {
        error "This design requires Vivado 2026.1 (running [version -short])."
    }

    create_project -force fim2 [file join $build_dir vivado] -part xck26-sfvc784-2LV-c
    set_property BOARD_PART xilinx.com:k26c:part0:2.0 [current_project]

    set result [source [file join $repo_dir board fim2.tcl]]
    if {[string is integer -strict $result] && $result != 0} {
        error "board/fim2.tcl failed with status $result."
    }

    set bd_file [get_files -quiet */design_1.bd]
    if {[llength $bd_file] != 1} {
        error "Expected exactly one design_1.bd after sourcing board/fim2.tcl."
    }
    validate_bd_design
    save_bd_design
    generate_target all $bd_file
    add_files -norecurse [make_wrapper -files $bd_file -top]
    set_property top design_1_wrapper [current_fileset]
    update_compile_order -fileset sources_1

    # No -include_bit: this first handoff does not run synthesis/implementation.
    write_hw_platform -fixed -force -file [file join $build_dir fim2.xsa]
    close_project
} message options]} {
    puts stderr "XSA export failed: $message"
    puts stderr [dict get $options -errorinfo]
    exit 1
}
exit 0
