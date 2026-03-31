#----------------------------------------------------------------
# gen_padframe.tcl --
#
# Script to run in magic which automatically creates the layout
# for both the openframe padframe and the user project wrapper.
#
# TEMPLATE_MESSAGE
#----------------------------------------------------------------

# Enable math operators in Tcl
namespace path {::tcl::mathop ::tcl::mathfunc}

drc off
crashbackups stop
locking disable
units microns

# Add the I/O library path (see setup.sh)
addpath sg13cmos5l_io
addpath paramcells

# Ensure that the padframe layout does not already exist.
if {[file exists sg13cmos5l_padframe.mag]} {
    puts stderr "Padframe exists!  Back up and delete before rebuilding!"
    quit -noprompt
}

# Ensure that the project wrapper layout does not already exist.
if {[file exists openframe_project_wrapper.mag]} {
    puts stderr "Project wrapper exists!  Back up and delete before rebuilding!"
    quit -noprompt
}

# Define useful procedures

# Place a pad on the bottom row and move to the next position
proc place_pad_bottom {padname padcell {padid {}}} {
    getcell $padcell
    identify $padname
    set ibox [instance list abutment $padname]
    if {$padid != {}} {
	pushbox
	box move e 5.62
	box move s 100
	getcell bondpad_LX3CBX
	identify $padid
	popbox
    }
    box values {*}$ibox
    box move e [- [lindex $ibox 2] [lindex $ibox 0]]
}

# Place a pad on the right row and move to the next position
proc place_pad_right {padname padcell {padid {}}} {
    getcell $padcell 270
    identify $padname
    set ibox [instance list abutment $padname]
    if {$padid != {}} {
	pushbox
	box move e [box width]
	box move n 5.62
	getcell bondpad_LX3CBX 90
	identify $padid
	popbox
    }
    box values {*}$ibox
    box move n [- [lindex $ibox 3] [lindex $ibox 1]]
}

# Place a pad on the top row and move to the next position
proc place_pad_top {padname padcell {padid {}}} {
    getcell $padcell 180
    identify $padname
    set ibox [instance list abutment $padname]
    if {$padid != {}} {
	pushbox
	box move e 5.62
	box move n [box height]
	getcell bondpad_LX3CBX
	identify $padid
	popbox
    }
    box values {*}$ibox
    box move e [- [lindex $ibox 2] [lindex $ibox 0]]
}

# Place a pad on the left row and move to the next position
proc place_pad_left {padname padcell {padid {}}} {
    getcell $padcell 90
    identify $padname
    set ibox [instance list abutment $padname]
    if {$padid != {}} {
	pushbox
	box move w 100
	box move n 5.62
	getcell bondpad_LX3CBX 90
	identify $padid
	popbox
    }
    box values {*}$ibox
    box move n [- [lindex $ibox 3] [lindex $ibox 1]]
}

# Find a pad cell by name and drop a label on it
proc label_pad {pad_name pad_text} {
    select cell $pad_name
    select area glass
    box values {*}[select bbox]
    paint m5
    label $pad_text FreeSans 20 0 0 0 c m5
    port make
}

# Label an internal pad signal on the bottom
proc label_bottom_signal {pad_name pin_name pin_text} {
    goto ${pad_name}/${pin_name}
    box move n [box height]
    box move s 1
    box height 2
    box grow e 0.1
    box grow w 0.1
    paint m2
    label $pin_text FreeSans 0.3 90 0 0 c m2
    port make
}

# Label an internal pad signal on the right
proc label_right_signal {pad_name pin_name pin_text} {
    goto ${pad_name}/${pin_name}
    box move w 1
    box width 2
    box grow n 0.1
    box grow s 0.1
    paint m3
    label $pin_text FreeSans 0.3 0 0 0 c m3
    port make
}

# Label an internal pad signal on the top
proc label_top_signal {pad_name pin_name pin_text} {
    goto ${pad_name}/${pin_name}
    box move s 1
    box height 2
    box grow e 0.1
    box grow w 0.1
    paint m2
    label $pin_text FreeSans 0.3 90 0 0 c m2
    port make
}

# Label an internal pad signal on the left
proc label_left_signal {pad_name pin_name pin_text} {
    goto ${pad_name}/${pin_name}
    box move e [box width]
    box move w 1
    box width 2
    box grow n 0.1
    box grow s 0.1
    paint m3
    label $pin_text FreeSans 0.3 0 0 0 c m3
    port make
}

# Label an analog pad signal on the left
proc label_left_analog {pad_name pin_name pin_text} {
    goto ${pad_name}/${pin_name}
    box move e [box width]
    box width 1.1
    paint m3
    box width 0.8 
    paint m3
    label $pin_text FreeSans 0.3 90 0 0 c m3
    port make
}

# Label an analog pad signal on the right
proc label_right_analog {pad_name pin_name pin_text} {
    goto ${pad_name}/${pin_name}
    box width 1.1
    box move w 1.1
    paint m3
    box width 0.8
    label $pin_text FreeSans 0.3 90 0 0 c m3
    port make
}

# Label an analog pad signal on the top
proc label_top_analog {pad_name pin_name pin_text} {
    goto ${pad_name}/${pin_name}
    box height 1.1
    box move s 1.1
    paint m2
    box height 0.8
    label $pin_text FreeSans 0.3 0 0 0 c m2
    port make
}

# Add routed "constant_block" cells.  Given a cell instance name, the
# constant block is set off to the side under the pad bus.

proc add_constant_bottom {cellname instname} {
    select cell $cellname
    # move to the corner position of the cell
    box move n [box height]
    box move e [box width]
    box move s 25.5
    getcell constant_block_vrouted
    identify $instname
}

proc add_constant_left {cellname instname} {
    select cell $cellname
    # move to the corner position of the cell
    box move e [box width]
    box move s 10
    box move w 26
    getcell constant_block_hrouted 180v
    identify $instname
}

proc add_constant_right {cellname instname} {
    select cell $cellname
    # move to the corner position of the cell
    box move n [box height]
    box move w 0.5
    getcell constant_block_hrouted v
    identify $instname
}

# Create the new padframe cell.
load sg13cmos5l_padframe -silent

# The Pad corner is inside the frame by the distance of a pad length (as defined
# here, 100um)
box values 100 100 100 100

# Generate the common pad cell
if {![file exists paramcells/bondpad_LX3CBX.mag] \
		&& ![cellname list exists bondpad_LX3CBX]} {
    magic::gencell sg13cmos5l::bondpad bondpad_0 height 100 width 70 depth 5 \
		class special shape square
    # Need the cell, not the instance.
    select cell bondpad_0
    delete
    # Move the bondpad location to the paramcells/ subdirectory
    cellname filepath bondpad_LX3CBX paramcells
}

# Create the padframe (see documentation)

# Place pads starting at the lower left corner and progressing
# counterclockwise.

place_pad_bottom pad_corner_sw	sg13cmos5l_Corner
place_pad_bottom pad_vccd_0 	sg13cmos5l_IOPadVdd	 pad_0
place_pad_bottom spacer_0	sg13cmos5l_Filler10000
place_pad_bottom pad_vssio_0 	sg13cmos5l_IOPadIOVss	 pad_1
place_pad_bottom spacer_1	sg13cmos5l_Filler10000
place_pad_bottom pad_resetb 	sg13cmos5l_IOPadIn	 pad_2
place_pad_bottom spacer_2	sg13cmos5l_Filler10000
place_pad_bottom pad_gpio_38 	PAD_38_TYPE	 	 pad_3
place_pad_bottom spacer_3	sg13cmos5l_Filler10000
place_pad_bottom pad_vssd_0 	sg13cmos5l_IOPadVss	 pad_4
place_pad_bottom spacer_4	sg13cmos5l_Filler10000
place_pad_bottom pad_gpio_39 	PAD_39_TYPE		 pad_5
place_pad_bottom spacer_5	sg13cmos5l_Filler10000
place_pad_bottom pad_gpio_40 	PAD_40_TYPE		 pad_6
place_pad_bottom spacer_6	sg13cmos5l_Filler10000
place_pad_bottom pad_gpio_41 	PAD_41_TYPE		 pad_7
place_pad_bottom spacer_7	sg13cmos5l_Filler10000
place_pad_bottom pad_gpio_42 	PAD_42_TYPE		 pad_8
place_pad_bottom spacer_8	sg13cmos5l_Filler10000
place_pad_bottom pad_gpio_43 	PAD_43_TYPE		 pad_9
place_pad_bottom spacer_9	sg13cmos5l_Filler10000
place_pad_bottom pad_vssio_1 	sg13cmos5l_IOPadIOVss	 pad_10
place_pad_bottom spacer_10	sg13cmos5l_Filler10000
place_pad_bottom pad_vddio_0 	sg13cmos5l_IOPadIOVdd	 pad_11

place_pad_right	 pad_corner_se	sg13cmos5l_Corner
place_pad_right	 pad_gpio_0	PAD_0_TYPE 		 pad_12
place_pad_right  spacer_11	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_1	PAD_1_TYPE 		 pad_13
place_pad_right  spacer_12	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_2	PAD_2_TYPE 		 pad_14
place_pad_right  spacer_13	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_3	PAD_3_TYPE 		 pad_15
place_pad_right  spacer_14	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_4	PAD_4_TYPE 		 pad_16
place_pad_right  spacer_15	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_5	PAD_5_TYPE 		 pad_17
place_pad_right  spacer_16	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_6	PAD_6_TYPE 		 pad_18
place_pad_right  spacer_17	sg13cmos5l_Filler10000
place_pad_right	 pad_vssio_2	sg13cmos5l_IOPadIOVss	 pad_19
place_pad_right  spacer_18	sg13cmos5l_Filler10000
place_pad_right	 pad_vssd_1	sg13cmos5l_IOPadVss	 pad_20
place_pad_right  spacer_19	sg13cmos5l_Filler10000
place_pad_right	 pad_vddio_1	sg13cmos5l_IOPadIOVdd	 pad_21
place_pad_right  spacer_20	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_7	PAD_7_TYPE	 	 pad_22
place_pad_right  spacer_21	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_8	PAD_8_TYPE	 	 pad_23
place_pad_right  spacer_22	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_9	PAD_9_TYPE	 	 pad_24
place_pad_right  spacer_23	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_10	PAD_10_TYPE	 	 pad_25
place_pad_right  spacer_24	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_11	PAD_11_TYPE	 	 pad_26
place_pad_right  spacer_25	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_12	PAD_12_TYPE	 	 pad_27
place_pad_right  spacer_26	sg13cmos5l_Filler10000
place_pad_right	 pad_vddio_2	sg13cmos5l_IOPadIOVdd	 pad_28
place_pad_right  spacer_27	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_13	PAD_13_TYPE	 	 pad_29
place_pad_right  spacer_28	sg13cmos5l_Filler10000
place_pad_right	 pad_vccd_1 	sg13cmos5l_IOPadVdd	 pad_30
place_pad_right  spacer_29	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_14	PAD_14_TYPE	 	 pad_31

# Go back to the bottom left corner
set ibox [instance list abutment pad_corner_sw]
box values {*}$ibox
box move n [- [lindex $ibox 3] [lindex $ibox 1]]

# Place the remainder in clockwise order
place_pad_left	 pad_vddio_5	sg13cmos5l_IOPadIOVdd	 pad_63
place_pad_left   spacer_30	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_37 	PAD_37_TYPE 		 pad_62
place_pad_left   spacer_31	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_36 	PAD_36_TYPE 		 pad_61
place_pad_left   spacer_32	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_35	PAD_35_TYPE	 	 pad_60
place_pad_left   spacer_33	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_34	PAD_34_TYPE	 	 pad_59
place_pad_left   spacer_34	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_33	PAD_33_TYPE	 	 pad_58
place_pad_left   spacer_35	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_32	PAD_32_TYPE	 	 pad_57
place_pad_left   spacer_36	sg13cmos5l_Filler10000
place_pad_left	 pad_vssd_2	sg13cmos5l_IOPadVss	 pad_56
place_pad_left   spacer_37	sg13cmos5l_Filler10000
place_pad_left	 pad_vddio_4	sg13cmos5l_IOPadIOVdd	 pad_55
place_pad_left   spacer_38	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_31	PAD_31_TYPE	 	 pad_54
place_pad_left   spacer_39	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_30	PAD_30_TYPE	 	 pad_53
place_pad_left   spacer_40	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_29	PAD_29_TYPE	 	 pad_52
place_pad_left   spacer_41	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_28	PAD_28_TYPE	 	 pad_51
place_pad_left   spacer_42	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_27	PAD_27_TYPE	 	 pad_50
place_pad_left   spacer_43	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_26	PAD_26_TYPE	 	 pad_49
place_pad_left   spacer_44	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_25	PAD_25_TYPE	 	 pad_48
place_pad_left   spacer_45	sg13cmos5l_Filler10000
place_pad_left	 pad_vssio_5	sg13cmos5l_IOPadIOVss	 pad_47
place_pad_left   spacer_46	sg13cmos5l_Filler10000
place_pad_left	 pad_vddio_3	sg13cmos5l_IOPadIOVdd	 pad_46
place_pad_left   spacer_47	sg13cmos5l_Filler10000
place_pad_left	 pad_vccd_2 	sg13cmos5l_IOPadVdd	 pad_45
place_pad_left   spacer_48	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_24	PAD_24_TYPE	 	 pad_44
place_pad_left	 pad_corner_nw	sg13cmos5l_Corner

# Move back down and to the right
set ibox [instance list abutment pad_corner_nw]
box values {*}$ibox
box move e [- [lindex $ibox 2] [lindex $ibox 0]]

place_pad_top	pad_option_0	sg13cmos5l_IOPadIn	 pad_43
place_pad_top   spacer_49	sg13cmos5l_Filler10000
place_pad_top	pad_gpio_23	PAD_23_TYPE	 	 pad_42
place_pad_top   spacer_50	sg13cmos5l_Filler10000
place_pad_top	pad_gpio_22	PAD_22_TYPE	 	 pad_41
place_pad_top   spacer_51	sg13cmos5l_Filler10000
place_pad_top	pad_gpio_21	PAD_21_TYPE	 	 pad_40
place_pad_top   spacer_52	sg13cmos5l_Filler10000
place_pad_top	pad_gpio_20	PAD_20_TYPE	 	 pad_39
place_pad_top   spacer_53	sg13cmos5l_Filler10000
place_pad_top	pad_gpio_19	PAD_19_TYPE	 	 pad_38
place_pad_top   spacer_54	sg13cmos5l_Filler10000
place_pad_top	pad_vssio_4	sg13cmos5l_IOPadIOVss	 pad_37
place_pad_top   spacer_55	sg13cmos5l_Filler10000
place_pad_top	pad_gpio_18	PAD_18_TYPE	 	 pad_36
place_pad_top   spacer_56	sg13cmos5l_Filler10000
place_pad_top	pad_gpio_17	PAD_17_TYPE	 	 pad_35
place_pad_top   spacer_57	sg13cmos5l_Filler10000
place_pad_top	pad_gpio_16	PAD_16_TYPE	 	 pad_34
place_pad_top   spacer_58	sg13cmos5l_Filler10000
place_pad_top	pad_vssio_3	sg13cmos5l_IOPadIOVss	 pad_33
place_pad_top   spacer_59	sg13cmos5l_Filler10000
place_pad_top	pad_gpio_15	PAD_15_TYPE	 	 pad_32
place_pad_top	pad_corner_ne	sg13cmos5l_Corner

# Everything needs to be expanded for the pad labeling to work.
select top cell
expand

# Label all pads.
label_pad pad_0 vccd
label_pad pad_1 vssio
label_pad pad_2 resetb
label_pad pad_3 gpio\[38\]
label_pad pad_4 vssd
label_pad pad_5 gpio\[39\]
label_pad pad_6 gpio\[40\]
label_pad pad_7 gpio\[41\]
label_pad pad_8 gpio\[42\]
label_pad pad_9 gpio\[43\]
label_pad pad_10 vssio
label_pad pad_11 vddio
label_pad pad_12 gpio\[0\]
label_pad pad_13 gpio\[1\]
label_pad pad_14 gpio\[2\]
label_pad pad_15 gpio\[3\]
label_pad pad_16 gpio\[4\]
label_pad pad_17 gpio\[5\]
label_pad pad_18 gpio\[6\]
label_pad pad_19 vssio
label_pad pad_20 vssd
label_pad pad_21 vddio
label_pad pad_22 gpio\[7\]
label_pad pad_23 gpio\[8\]
label_pad pad_24 gpio\[9\]
label_pad pad_25 gpio\[10\]
label_pad pad_26 gpio\[11\]
label_pad pad_27 gpio\[12\]
label_pad pad_28 vddio
label_pad pad_29 gpio\[13\]
label_pad pad_30 vccd
label_pad pad_31 gpio\[14\]
label_pad pad_32 gpio\[15\]
label_pad pad_33 vssio
label_pad pad_34 gpio\[16\]
label_pad pad_35 gpio\[17\]
label_pad pad_36 gpio\[18\]
label_pad pad_37 vssio
label_pad pad_38 gpio\[19\]
label_pad pad_39 gpio\[20\]
label_pad pad_40 gpio\[21\]
label_pad pad_41 gpio\[22\]
label_pad pad_42 gpio\[23\]
label_pad pad_43 option
label_pad pad_44 gpio\[24\]
label_pad pad_45 vccd
label_pad pad_46 vddio
label_pad pad_47 vssio
label_pad pad_48 gpio\[25\]
label_pad pad_49 gpio\[26\]
label_pad pad_50 gpio\[27\]
label_pad pad_51 gpio\[28\]
label_pad pad_52 gpio\[29\]
label_pad pad_53 gpio\[30\]
label_pad pad_54 gpio\[31\]
label_pad pad_55 vddio
label_pad pad_56 vssd
label_pad pad_57 gpio\[32\]
label_pad pad_58 gpio\[33\]
label_pad pad_59 gpio\[34\]
label_pad pad_60 gpio\[35\]
label_pad pad_61 gpio\[36\]
label_pad pad_62 gpio\[37\]
label_pad pad_63 vddio

# Label all internal digital pins

label_bottom_signal pad_resetb  p2c    resetb_in
label_top_signal   pad_option_0 p2c   option_in

PAD_0_SIGNALS
PAD_1_SIGNALS
PAD_2_SIGNALS
PAD_3_SIGNALS
PAD_4_SIGNALS
PAD_5_SIGNALS
PAD_7_SIGNALS
PAD_8_SIGNALS
PAD_9_SIGNALS
PAD_10_SIGNALS
PAD_11_SIGNALS
PAD_12_SIGNALS
PAD_13_SIGNALS
PAD_14_SIGNALS
PAD_15_SIGNALS
PAD_16_SIGNALS
PAD_17_SIGNALS
PAD_18_SIGNALS
PAD_19_SIGNALS
PAD_20_SIGNALS
PAD_21_SIGNALS
PAD_22_SIGNALS
PAD_23_SIGNALS
PAD_24_SIGNALS
PAD_25_SIGNALS
PAD_26_SIGNALS
PAD_27_SIGNALS
PAD_28_SIGNALS
PAD_29_SIGNALS
PAD_30_SIGNALS
PAD_31_SIGNALS
PAD_32_SIGNALS
PAD_33_SIGNALS
PAD_34_SIGNALS
PAD_35_SIGNALS
PAD_36_SIGNALS
PAD_37_SIGNALS
PAD_38_SIGNALS
PAD_39_SIGNALS
PAD_40_SIGNALS
PAD_41_SIGNALS
PAD_42_SIGNALS
PAD_43_SIGNALS

# Set the padframe bounding box
select top cell
set topbox [box values]
property FIXED_BBOX $topbox

# Add text decorations
# Lower left:  Add the copyright block
box position [lindex $topbox 0] [lindex $topbox 1]
box move e 10
box move n 2
getcell copyright_block
identify copyright_block

# Lower right:  Add the project ID text
box position [lindex $topbox 2] [lindex $topbox 1]
box move w 172	 ;# width of text block
box move w 35
box move n 20
getcell user_id_textblock
identify user_id_textblock

# Upper left:  Add the Caravel logo and motto
box position [lindex $topbox 0] [lindex $topbox 3]
box move s 78	;# height of caravel logo
box move e 20
box move s 14
getcell caravel_logo
identify caravel_logo
box position [lindex $topbox 0] [lindex $topbox 3]
box move s 22	;# height of caravel motto
box move e 130
box move s 42
getcell caravel_motto
identify caravel_motto

# Upper right:  Add the open source hardware logo
box position [lindex $topbox 2] [lindex $topbox 3]
box move w 70
box move s 25
box move w 141	;# width of open_source logo
box move s 55	;# height of open_source logo
getcell open_source
identify open_source

# Lower right:  Add the project ID ROM block
# above the project ID text
box position [lindex $topbox 2] [lindex $topbox 1]
box move w 320
box move n 80
getcell user_id_routing
identify project_id

# Add constant blocks (digital one/zero outputs) next to
# the digital bidirectional pads
CONSTANT_BLOCKS

CONSTANT_SIGNALS

label_bottom_signal  project_id	mask_rev\[0\]   mask_rev\[0\]
label_bottom_signal  project_id	mask_rev\[1\]   mask_rev\[1\]
label_bottom_signal  project_id	mask_rev\[2\]   mask_rev\[2\]
label_bottom_signal  project_id	mask_rev\[3\]   mask_rev\[3\]
label_bottom_signal  project_id	mask_rev\[4\]   mask_rev\[4\]
label_bottom_signal  project_id	mask_rev\[5\]   mask_rev\[5\]
label_bottom_signal  project_id	mask_rev\[6\]   mask_rev\[6\]
label_bottom_signal  project_id	mask_rev\[7\]   mask_rev\[7\]
label_bottom_signal  project_id	mask_rev\[8\]   mask_rev\[8\]
label_bottom_signal  project_id	mask_rev\[9\]   mask_rev\[9\]
label_bottom_signal  project_id	mask_rev\[10\]  mask_rev\[10\]
label_bottom_signal  project_id	mask_rev\[11\]  mask_rev\[11\]
label_bottom_signal  project_id	mask_rev\[12\]  mask_rev\[12\]
label_bottom_signal  project_id	mask_rev\[13\]  mask_rev\[13\]
label_bottom_signal  project_id	mask_rev\[14\]  mask_rev\[14\]
label_bottom_signal  project_id	mask_rev\[15\]  mask_rev\[15\]
label_bottom_signal  project_id	mask_rev\[16\]  mask_rev\[16\]
label_bottom_signal  project_id	mask_rev\[17\]  mask_rev\[17\]
label_bottom_signal  project_id	mask_rev\[18\]  mask_rev\[18\]
label_bottom_signal  project_id	mask_rev\[19\]  mask_rev\[19\]
label_bottom_signal  project_id	mask_rev\[20\]  mask_rev\[20\]
label_bottom_signal  project_id	mask_rev\[21\]  mask_rev\[21\]
label_bottom_signal  project_id	mask_rev\[22\]  mask_rev\[22\]
label_bottom_signal  project_id	mask_rev\[23\]  mask_rev\[23\]
label_bottom_signal  project_id	mask_rev\[24\]  mask_rev\[24\]
label_bottom_signal  project_id	mask_rev\[25\]  mask_rev\[25\]
label_bottom_signal  project_id	mask_rev\[26\]  mask_rev\[26\]
label_bottom_signal  project_id	mask_rev\[27\]  mask_rev\[27\]
label_bottom_signal  project_id	mask_rev\[28\]  mask_rev\[28\]
label_bottom_signal  project_id	mask_rev\[29\]  mask_rev\[29\]
label_bottom_signal  project_id	mask_rev\[30\]  mask_rev\[30\]
label_bottom_signal  project_id	mask_rev\[31\]  mask_rev\[31\]

# Create routes for the power supplies into the project area
# and label them.

# Bottom power pads

select cell pad_vccd_0
box values {*}[instance list abutment]
box grow s -141
box grow n 3
fill n m5
box move n [box height]
box move s 4
box height 4
box grow w -8
box grow e -8
paint m5
label vccd FreeSans 4 0 0 0 c m5
port make

select cell pad_vssio_0
box values {*}[instance list abutment]
box grow s -133.9
box grow w -10
box grow e -5
box grow n 3
fill n m2
box move n [box height]
box move s 4
box height 4
box grow w -5.58
paint m2
label vssio FreeSans 4 0 0 0 c m2
port make

select cell pad_vssd_0
box values {*}[instance list abutment]
box grow s -158
box grow w -10
box grow e -5
box grow n 3
fill n m2
box move n [box height]
box move s 4
box height 4
box grow w -5.58
paint m2
label vssd FreeSans 4 0 0 0 c m2
port make

select cell pad_vssio_1
box values {*}[instance list abutment]
box grow s -133.9
box grow w -10
box grow e -5
box grow n 3
fill n m2
box move n [box height]
box move s 4
box height 4
box grow w -5.58
paint m2
label vssio FreeSans 4 0 0 0 c m2
port make

select cell pad_vddio_0
box values {*}[instance list abutment]
box grow s -93.6
box grow w -7
box grow e -7
box grow n 3
fill n m5
box move n [box height]
box move s 4
box height 4
paint m5
label vddio FreeSans 4 0 0 0 c m5
port make

# Right power pads

select cell pad_vssio_2
box values {*}[instance list abutment]
box grow e -134
box grow w 3
box grow n -5
box grow s -10
fill w m2
box width 4
box grow s -5.58
paint m2
label vssio FreeSans 4 270 0 0 c m2
port make

select cell pad_vssd_1
box values {*}[instance list abutment]
box grow e -158
box grow s -10
box grow n -5
box grow w 3
fill w m2
box width 4
box grow s -5.58
paint m2
label vssd FreeSans 4 270 0 0 c m2
port make

select cell pad_vddio_1
box values {*}[instance list abutment]
box grow e -93.6
box grow s -7
box grow n -7
box grow w 3
fill w m5
box width 4
paint m5
label vddio FreeSans 4 270 0 0 c m5
port make

select cell pad_vddio_2
box values {*}[instance list abutment]
box grow e -93.6
box grow s -7
box grow n -7
box grow w 3
fill w m5
box width 4
paint m5
label vddio FreeSans 4 270 0 0 c m5
port make

select cell pad_vccd_1
box values {*}[instance list abutment]
box grow e -141
box grow w 3
fill w m5
box width 4
box grow n -8
box grow s -8
paint m5
label vccd FreeSans 4 270 0 0 c m5
port make

# Top power pads

select cell pad_vssio_3
box values {*}[instance list abutment]
box grow n -134
box grow s 3
box grow w -5
box grow e -10
fill s m2
box height 4
box grow e -5.58
paint m2
label vssio FreeSans 4 0 0 0 c m2
port make

select cell pad_vssio_4
box values {*}[instance list abutment]
box grow n -134
box grow s 3
box grow w -5
box grow e -10
fill s m2
box height 4
box grow e -5.58
paint m2
label vssio FreeSans 4 0 0 0 c m2
port make

# Left power pins

select cell pad_vccd_2
box values {*}[instance list abutment]
box grow w -141
box grow e 3
fill e m5
box move e [box width]
box move w 4
box width 4
box grow n -8
box grow s -8
paint m5
label vccd FreeSans 4 270 0 0 c m5
port make

select cell pad_vddio_3
box values {*}[instance list abutment]
box grow w -93.6
box grow s -7
box grow n -7
box grow e 3
fill e m5
box move e [box width]
box move w 4
box width 4
paint m5
label vddio FreeSans 4 270 0 0 c m5
port make

select cell pad_vssio_5
box values {*}[instance list abutment]
box grow w -134
box grow s -5
box grow n -10
box grow e 3
fill e m2
box move e [box width]
box move w 4
box width 4
box grow n -5.58
paint m2
label vssio FreeSans 4 270 0 0 c m2
port make

select cell pad_vddio_4
box values {*}[instance list abutment]
box grow w -93.6
box grow s -7
box grow n -7
box grow e 3
fill e m5
box move e [box width]
box move w 4
box width 4
paint m5
label vddio FreeSans 4 270 0 0 c m5
port make

select cell pad_vssd_2
box values {*}[instance list abutment]
box grow w -158
box grow n -10
box grow s -5
box grow e 3
fill e m2
box move e [box width]
box move w 4
box width 4
box grow n -5.58
paint m2
label vssd FreeSans 4 270 0 0 c m2
port make

select cell pad_vddio_5
box values {*}[instance list abutment]
box grow w -93.6
box grow s -7
box grow n -7
box grow e 3
fill e m5
box move e [box width]
box move w 4
box width 4
paint m5
label vddio FreeSans 4 270 0 0 c m5
port make

writeall force sg13cmos5l_padframe
writeall force bondpad_LX3CBX

# Create a cell containing just the pad labels which can be copied (flattened)
# into the final top level cell

select top cell
unexpand
set topllx [lindex $topbox 0]
set toplly [lindex $topbox 1]
set topurx [lindex $topbox 2]
set topury [lindex $topbox 3]
# bottom row
box values $topllx $toplly $topurx 100
select area m5
# left row
box values $topllx $toplly 100 $topury
select more area m5
# top row
box values $topllx $topury $topurx $topury
box grow s 100
select more area m5
# right row
box values $topurx $toplly $topurx $topury
box grow w 100
select more area m5
select save padframe_pins


# Create the user project wrapper
#
# Find the center area inside the padframe.
# Select the labels that were added above.
# Create a border around the routable area and add obstruction layers
# to prevent routing close to the padframe power rails.
#
# Note that this cell is not part of the padframe but belongs in the
# openframe top level.  It is generated here because its layout is
# dependent on how the padframe is constructed.

select top cell
expand
box grow c -279
select area m2,m3,via,via2,m5
select less area labels
unexpand
select more area labels
select save openframe_project_wrapper
load openframe_project_wrapper
select top cell
tech unlock *
contact erase via
contact erase via2
paint comment
box grow c -0.5
erase comment
select top cell
box height 2
erase m3
paint obsm1,obsm3
select top cell
box width 2
erase m2
paint obsm1,obsm2
select top cell
box move e [box width]
box move w 2
box width 2
erase m2
paint obsm1,obsm2
select top cell
box move n [box height]
box move s 2
box height 2
erase m3
paint obsm1,obsm3

writeall force openframe_project_wrapper

# quit -noprompt

