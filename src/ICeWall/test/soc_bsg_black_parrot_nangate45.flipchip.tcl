
source "helpers.tcl"

read_lef NangateOpenCellLibrary.mod.lef
read_lef dummy_pads.lef

read_liberty dummy_pads.lib

read_verilog soc_bsg_black_parrot_nangate45/soc_bsg_black_parrot.flipchip.v

link_design soc_bsg_black_parrot

if {[catch {ICeWall load_footprint soc_bsg_black_parrot_nangate45/bsg_black_parrot.flip-chip.strategy} msg]} {
  puts $errorInfo
  puts $msg
  exit
}

initialize_floorplan \
  -die_area  {0 0 3000.000 3000.000} \
  -core_area {180.012 180.096 2819.964 2819.712} \
  -site FreePDK45_38x28_10R_NP_162NW_34O
make_tracks

source ../../../test/Nangate45/Nangate45.tracks

if {[catch {ICeWall init_footprint soc_bsg_black_parrot_nangate45/soc_bsg_black_parrot.flipchip.sigmap} msg]} {
  puts $errorInfo
  puts $msg
  exit
}

set def_file [make_result_file "soc_bsg_black_parrot_nangate45.flipchip.def"]

write_def $def_file
exec sed -e "/END SPECIALNETS/r[ICeWall::get_footprint_rdl_cover_file_name]" $def_file > $def_file

diff_files $def_file "soc_bsg_black_parrot_nangate45.flipchip.defok"
