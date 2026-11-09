# Synthesize and implement a carrier's project (as created by export_xsa.tcl),
# copy the bitstream out of the run directory, and export a second XSA that
# includes it. SDTGen copies that bitstream into the SDT, and gen-machine-conf
# then puts it in BOOT.BIN.
#
# vivado -mode batch -source build_bit.tcl -tclargs <project.xpr> <output.bit> <output.xsa> <jobs>
#
# All paths must be absolute.
if {[llength $argv] != 4} {
    puts stderr "usage: -tclargs <project.xpr> <output.bit> <output.xsa> <jobs>"
    exit 1
}
lassign $argv xpr bit xsa jobs

if {[catch {
    open_project $xpr
    reset_run synth_1
    launch_runs impl_1 -to_step write_bitstream -jobs $jobs
    wait_on_run impl_1

    set impl [get_runs impl_1]
    if {[get_property PROGRESS $impl] ne "100%"} {
        error "Implementation did not finish: [get_property STATUS $impl]"
    }
    set run_bit [file join [get_property DIRECTORY $impl] [get_property top [current_fileset]].bit]
    if {![file isfile $run_bit]} {
        error "No bitstream at $run_bit"
    }
    file copy -force $run_bit $bit
    puts "Timing: WNS [get_property STATS.WNS $impl] ns, WHS [get_property STATS.WHS $impl] ns"
    open_run impl_1
    write_hw_platform -fixed -include_bit -force $xsa
    close_project
    puts "Wrote $bit and $xsa"
} message options]} {
    puts stderr "Bitstream build failed: $message"
    puts stderr [dict get $options -errorinfo]
    exit 1
}
exit 0
