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
    puts stderr "Padframe exists!  Delete before rebuilding!"
    quit -noprompt
}

# Ensure that the project wrapper layout does not already exist.
if {[file exists openframe_project_wrapper.mag]} {
    puts stderr "Project wrapper exists!  Delete before rebuilding!"
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
place_pad_bottom pad_gpio_38 	sg13cmos5l_IOPadIn	 pad_3	;# clock
place_pad_bottom spacer_3	sg13cmos5l_Filler10000
place_pad_bottom pad_vssd_0 	sg13cmos5l_IOPadVss	 pad_4
place_pad_bottom spacer_4	sg13cmos5l_Filler10000
place_pad_bottom pad_gpio_39 	sg13cmos5l_IOPadInOut4mA pad_5	;# flash
place_pad_bottom spacer_5	sg13cmos5l_Filler10000
place_pad_bottom pad_gpio_40 	sg13cmos5l_IOPadInOut4mA pad_6	;# flash
place_pad_bottom spacer_6	sg13cmos5l_Filler10000
place_pad_bottom pad_gpio_41 	sg13cmos5l_IOPadInOut4mA pad_7	;# flash
place_pad_bottom spacer_7	sg13cmos5l_Filler10000
place_pad_bottom pad_gpio_42 	sg13cmos5l_IOPadInOut4mA pad_8	;# flash
place_pad_bottom spacer_8	sg13cmos5l_Filler10000
place_pad_bottom pad_gpio_43 	sg13cmos5l_IOPadInOut4mA pad_9	;# gpio
place_pad_bottom spacer_9	sg13cmos5l_Filler10000
place_pad_bottom pad_vssio_1 	sg13cmos5l_IOPadIOVss	 pad_10
place_pad_bottom spacer_10	sg13cmos5l_Filler10000
place_pad_bottom pad_vddio_0 	sg13cmos5l_IOPadIOVdd	 pad_11

place_pad_right	 pad_corner_se	sg13cmos5l_Corner
place_pad_right	 pad_gpio_0	sg13cmos5l_IOPadInOut4mA pad_12	;# gpio
place_pad_right  spacer_11	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_1	sg13cmos5l_IOPadInOut4mA pad_13	;# SPI
place_pad_right  spacer_12	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_2	sg13cmos5l_IOPadInOut4mA pad_14	;# SPI
place_pad_right  spacer_13	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_3	sg13cmos5l_IOPadInOut4mA pad_15	;# SPI
place_pad_right  spacer_14	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_4	sg13cmos5l_IOPadInOut4mA pad_16	;# SPI
place_pad_right  spacer_15	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_5	sg13cmos5l_IOPadInOut4mA pad_17	;# UART
place_pad_right  spacer_16	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_6	sg13cmos5l_IOPadInOut4mA pad_18	;# UART
place_pad_right  spacer_17	sg13cmos5l_Filler10000
place_pad_right	 pad_vssio_2	sg13cmos5l_IOPadIOVss	 pad_19
place_pad_right  spacer_18	sg13cmos5l_Filler10000
place_pad_right	 pad_vssd_1	sg13cmos5l_IOPadVss	 pad_20
place_pad_right  spacer_19	sg13cmos5l_Filler10000
place_pad_right	 pad_vddio_1	sg13cmos5l_IOPadIOVdd	 pad_21
place_pad_right  spacer_20	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_7	sg13cmos5l_IOPadAnalog	 pad_22	;# analog
place_pad_right  spacer_21	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_8	sg13cmos5l_IOPadAnalog	 pad_23	;# analog
place_pad_right  spacer_22	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_9	sg13cmos5l_IOPadAnalog	 pad_24	;# analog
place_pad_right  spacer_23	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_10	sg13cmos5l_IOPadAnalog	 pad_25	;# analog
place_pad_right  spacer_24	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_11	sg13cmos5l_IOPadAnalog	 pad_26	;# analog
place_pad_right  spacer_25	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_12	sg13cmos5l_IOPadAnalog	 pad_27	;# analog
place_pad_right  spacer_26	sg13cmos5l_Filler10000
place_pad_right	 pad_vddio_2	sg13cmos5l_IOPadIOVdd	 pad_28
place_pad_right  spacer_27	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_13	sg13cmos5l_IOPadAnalog	 pad_29	;# analog
place_pad_right  spacer_28	sg13cmos5l_Filler10000
place_pad_right	 pad_vccd_1 	sg13cmos5l_IOPadVdd	 pad_30
place_pad_right  spacer_29	sg13cmos5l_Filler10000
place_pad_right	 pad_gpio_14	sg13cmos5l_IOPadAnalog	 pad_31	;# analog

# Go back to the bottom left corner
set ibox [instance list abutment pad_corner_sw]
box values {*}$ibox
box move n [- [lindex $ibox 3] [lindex $ibox 1]]

# Place the remainder in clockwise order
place_pad_left	 pad_vddio_5	sg13cmos5l_IOPadIOVdd	 pad_63
place_pad_left   spacer_30	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_37 	sg13cmos5l_IOPadInOut4mA pad_62	;# flash
place_pad_left   spacer_31	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_36 	sg13cmos5l_IOPadInOut4mA pad_61	;# flash
place_pad_left   spacer_32	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_35	sg13cmos5l_IOPadAnalog	 pad_60	;# analog
place_pad_left   spacer_33	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_34	sg13cmos5l_IOPadAnalog	 pad_59	;# analog
place_pad_left   spacer_34	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_33	sg13cmos5l_IOPadAnalog	 pad_58	;# analog
place_pad_left   spacer_35	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_32	sg13cmos5l_IOPadAnalog	 pad_57	;# analog
place_pad_left   spacer_36	sg13cmos5l_Filler10000
place_pad_left	 pad_vssd_2	sg13cmos5l_IOPadVss	 pad_56
place_pad_left   spacer_37	sg13cmos5l_Filler10000
place_pad_left	 pad_vddio_4	sg13cmos5l_IOPadIOVdd	 pad_55
place_pad_left   spacer_38	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_31	sg13cmos5l_IOPadAnalog	 pad_54	;# analog
place_pad_left   spacer_39	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_30	sg13cmos5l_IOPadAnalog	 pad_53	;# analog
place_pad_left   spacer_40	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_29	sg13cmos5l_IOPadAnalog	 pad_52	;# analog
place_pad_left   spacer_41	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_28	sg13cmos5l_IOPadAnalog	 pad_51	;# analog
place_pad_left   spacer_42	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_27	sg13cmos5l_IOPadAnalog	 pad_50	;# analog
place_pad_left   spacer_43	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_26	sg13cmos5l_IOPadAnalog	 pad_49	;# analog
place_pad_left   spacer_44	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_25	sg13cmos5l_IOPadAnalog	 pad_48	;# analog
place_pad_left   spacer_45	sg13cmos5l_Filler10000
place_pad_left	 pad_vssio_5	sg13cmos5l_IOPadIOVss	 pad_47
place_pad_left   spacer_46	sg13cmos5l_Filler10000
place_pad_left	 pad_vddio_3	sg13cmos5l_IOPadIOVdd	 pad_46
place_pad_left   spacer_47	sg13cmos5l_Filler10000
place_pad_left	 pad_vccd_2 	sg13cmos5l_IOPadVdd	 pad_45
place_pad_left   spacer_48	sg13cmos5l_Filler10000
place_pad_left	 pad_gpio_24	sg13cmos5l_IOPadAnalog	 pad_44	;# analog
place_pad_left	 pad_corner_nw	sg13cmos5l_Corner

# Move back down and to the right
set ibox [instance list abutment pad_corner_nw]
box values {*}$ibox
box move e [- [lindex $ibox 2] [lindex $ibox 0]]

place_pad_top	pad_option_0	sg13cmos5l_IOPadIn	 pad_43	;# spare
place_pad_top   spacer_49	sg13cmos5l_Filler10000
place_pad_top	pad_gpio_23	sg13cmos5l_IOPadAnalog	 pad_42	;# analog
place_pad_top   spacer_50	sg13cmos5l_Filler10000
place_pad_top	pad_gpio_22	sg13cmos5l_IOPadAnalog	 pad_41	;# analog
place_pad_top   spacer_51	sg13cmos5l_Filler10000
place_pad_top	pad_gpio_21	sg13cmos5l_IOPadAnalog	 pad_40	;# analog
place_pad_top   spacer_52	sg13cmos5l_Filler10000
place_pad_top	pad_gpio_20	sg13cmos5l_IOPadAnalog	 pad_39	;# analog
place_pad_top   spacer_53	sg13cmos5l_Filler10000
place_pad_top	pad_gpio_19	sg13cmos5l_IOPadAnalog	 pad_38	;# analog
place_pad_top   spacer_54	sg13cmos5l_Filler10000
place_pad_top	pad_vssio_4	sg13cmos5l_IOPadIOVss	 pad_37
place_pad_top   spacer_55	sg13cmos5l_Filler10000
place_pad_top	pad_gpio_18	sg13cmos5l_IOPadAnalog	 pad_36	;# analog
place_pad_top   spacer_56	sg13cmos5l_Filler10000
place_pad_top	pad_gpio_17	sg13cmos5l_IOPadAnalog	 pad_35	;# analog
place_pad_top   spacer_57	sg13cmos5l_Filler10000
place_pad_top	pad_gpio_16	sg13cmos5l_IOPadAnalog	 pad_34	;# analog
place_pad_top   spacer_58	sg13cmos5l_Filler10000
place_pad_top	pad_vssio_3	sg13cmos5l_IOPadIOVss	 pad_33
place_pad_top   spacer_59	sg13cmos5l_Filler10000
place_pad_top	pad_gpio_15	sg13cmos5l_IOPadAnalog	 pad_32	;# analog
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
label_bottom_signal pad_gpio_38 p2c    clock_in
label_bottom_signal pad_gpio_39 p2c    flash_csb_in
label_bottom_signal pad_gpio_39 c2p_en flash_csb_ena
label_bottom_signal pad_gpio_39 c2p    flash_csb_out
label_bottom_signal pad_gpio_40 p2c    flash_clk_in
label_bottom_signal pad_gpio_40 c2p_en flash_clk_ena
label_bottom_signal pad_gpio_40 c2p    flash_clk_out
label_bottom_signal pad_gpio_41 p2c    flash_io0_in
label_bottom_signal pad_gpio_41 c2p_en flash_io0_ena
label_bottom_signal pad_gpio_41 c2p    flash_io0_out
label_bottom_signal pad_gpio_42 p2c    flash_io1_in
label_bottom_signal pad_gpio_42 c2p_en flash_io1_ena
label_bottom_signal pad_gpio_42 c2p    flash_io1_out
label_bottom_signal pad_gpio_43 p2c    gpio0_in
label_bottom_signal pad_gpio_43 c2p_en gpio0_ena
label_bottom_signal pad_gpio_43 c2p    gpio0_out

label_right_signal pad_gpio_0  p2c    gpio1_in
label_right_signal pad_gpio_0  c2p_en gpio1_ena
label_right_signal pad_gpio_0  c2p    gpio1_out
label_right_signal pad_gpio_1  p2c    spi_SDO_in
label_right_signal pad_gpio_1  c2p_en spi_SDO_ena
label_right_signal pad_gpio_1  c2p    spi_SDO_out
label_right_signal pad_gpio_2  p2c    spi_SDI_in
label_right_signal pad_gpio_2  c2p_en spi_SDI_ena
label_right_signal pad_gpio_2  c2p    spi_SDI_out
label_right_signal pad_gpio_3  p2c    spi_CSB_in
label_right_signal pad_gpio_3  c2p_en spi_CSB_ena
label_right_signal pad_gpio_3  c2p    spi_CSB_out
label_right_signal pad_gpio_4  p2c    spi_SCK_in
label_right_signal pad_gpio_4  c2p_en spi_SCK_ena
label_right_signal pad_gpio_4  c2p    spi_SCK_out
label_right_signal pad_gpio_5  p2c    UART_Rx_in
label_right_signal pad_gpio_5  c2p_en UART_Rx_ena
label_right_signal pad_gpio_5  c2p    UART_Rx_out
label_right_signal pad_gpio_6  p2c    UART_Tx_in
label_right_signal pad_gpio_6  c2p_en UART_Tx_ena
label_right_signal pad_gpio_6  c2p    UART_Tx_out
label_top_signal   pad_option_0 p2c   option_in
label_left_signal  pad_gpio_36 p2c    flash_io2_in
label_left_signal  pad_gpio_36 c2p_en flash_io2_ena
label_left_signal  pad_gpio_36 c2p    flash_io2_out
label_left_signal  pad_gpio_37 p2c    flash_io3_in
label_left_signal  pad_gpio_37 c2p_en flash_io3_ena
label_left_signal  pad_gpio_37 c2p    flash_io3_out

# Label all internal analog pins
label_right_signal pad_gpio_7  padres analog_io_esd\[0\]
label_right_signal pad_gpio_8  padres analog_io_esd\[1\]
label_right_signal pad_gpio_9  padres analog_io_esd\[2\]
label_right_signal pad_gpio_10 padres analog_io_esd\[3\]
label_right_signal pad_gpio_11 padres analog_io_esd\[4\]
label_right_signal pad_gpio_12 padres analog_io_esd\[5\]
label_right_signal pad_gpio_13 padres analog_io_esd\[6\]
label_right_signal pad_gpio_14 padres analog_io_esd\[7\]
label_top_signal   pad_gpio_15 padres analog_io_esd\[8\]
label_top_signal   pad_gpio_16 padres analog_io_esd\[9\]
label_top_signal   pad_gpio_17 padres analog_io_esd\[10\]
label_top_signal   pad_gpio_18 padres analog_io_esd\[11\]
label_top_signal   pad_gpio_19 padres analog_io_esd\[12\]
label_top_signal   pad_gpio_20 padres analog_io_esd\[13\]
label_top_signal   pad_gpio_21 padres analog_io_esd\[14\]
label_top_signal   pad_gpio_22 padres analog_io_esd\[15\]
label_top_signal   pad_gpio_23 padres analog_io_esd\[16\]
label_left_signal  pad_gpio_24 padres analog_io_esd\[17\]
label_left_signal  pad_gpio_25 padres analog_io_esd\[18\]
label_left_signal  pad_gpio_26 padres analog_io_esd\[19\]
label_left_signal  pad_gpio_27 padres analog_io_esd\[20\]
label_left_signal  pad_gpio_28 padres analog_io_esd\[21\]
label_left_signal  pad_gpio_29 padres analog_io_esd\[22\]
label_left_signal  pad_gpio_30 padres analog_io_esd\[23\]
label_left_signal  pad_gpio_31 padres analog_io_esd\[24\]
label_left_signal  pad_gpio_32 padres analog_io_esd\[25\]
label_left_signal  pad_gpio_33 padres analog_io_esd\[26\]
label_left_signal  pad_gpio_34 padres analog_io_esd\[27\]
label_left_signal  pad_gpio_35 padres analog_io_esd\[28\]

label_right_analog pad_gpio_7  pad analog_io\[0\]
label_right_analog pad_gpio_8  pad analog_io\[1\]
label_right_analog pad_gpio_9  pad analog_io\[2\]
label_right_analog pad_gpio_10 pad analog_io\[3\]
label_right_analog pad_gpio_11 pad analog_io\[4\]
label_right_analog pad_gpio_12 pad analog_io\[5\]
label_right_analog pad_gpio_13 pad analog_io\[6\]
label_right_analog pad_gpio_14 pad analog_io\[7\]
label_top_analog   pad_gpio_15 pad analog_io\[8\]
label_top_analog   pad_gpio_16 pad analog_io\[9\]
label_top_analog   pad_gpio_17 pad analog_io\[10\]
label_top_analog   pad_gpio_18 pad analog_io\[11\]
label_top_analog   pad_gpio_19 pad analog_io\[12\]
label_top_analog   pad_gpio_20 pad analog_io\[13\]
label_top_analog   pad_gpio_21 pad analog_io\[14\]
label_top_analog   pad_gpio_22 pad analog_io\[15\]
label_top_analog   pad_gpio_23 pad analog_io\[16\]
label_left_analog  pad_gpio_24 pad analog_io\[17\]
label_left_analog  pad_gpio_25 pad analog_io\[18\]
label_left_analog  pad_gpio_26 pad analog_io\[19\]
label_left_analog  pad_gpio_27 pad analog_io\[20\]
label_left_analog  pad_gpio_28 pad analog_io\[21\]
label_left_analog  pad_gpio_29 pad analog_io\[22\]
label_left_analog  pad_gpio_30 pad analog_io\[23\]
label_left_analog  pad_gpio_31 pad analog_io\[24\]
label_left_analog  pad_gpio_32 pad analog_io\[25\]
label_left_analog  pad_gpio_33 pad analog_io\[26\]
label_left_analog  pad_gpio_34 pad analog_io\[27\]
label_left_analog  pad_gpio_35 pad analog_io\[28\]

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
add_constant_bottom pad_gpio_39	const_39
add_constant_bottom pad_gpio_40	const_40
add_constant_bottom pad_gpio_41 const_41
add_constant_bottom pad_gpio_42 const_42
add_constant_bottom pad_gpio_43 const_43
add_constant_right  pad_gpio_0  const_0
add_constant_right  pad_gpio_1  const_1
add_constant_right  pad_gpio_2  const_2
add_constant_right  pad_gpio_3  const_3
add_constant_right  pad_gpio_4  const_4
add_constant_right  pad_gpio_5  const_5
add_constant_right  pad_gpio_6  const_6
add_constant_left   pad_gpio_36 const_36
add_constant_left   pad_gpio_37 const_37

label_bottom_signal const_39	zero	flash_csb_zero
label_bottom_signal const_39	one	flash_csb_one
label_bottom_signal const_40	zero	flash_clk_zero
label_bottom_signal const_40	one	flash_clk_one
label_bottom_signal const_41	zero	flash_io0_zero
label_bottom_signal const_41	one	flash_io0_one
label_bottom_signal const_42	zero	flash_io1_zero
label_bottom_signal const_42	one	flash_io1_one
label_bottom_signal const_43	zero	gpio0_zero
label_bottom_signal const_43	one	gpio0_one
label_right_signal  const_0	zero	gpio1_zero
label_right_signal  const_0	one	gpio1_one
label_right_signal  const_1	zero	spi_SDO_zero
label_right_signal  const_1	one	spi_SDO_one
label_right_signal  const_2	zero	spi_SDI_zero
label_right_signal  const_2	one	spi_SDI_one
label_right_signal  const_3	zero	spi_CSB_zero
label_right_signal  const_3	one	spi_CSB_one
label_right_signal  const_4	zero	spi_SCK_zero
label_right_signal  const_4	one	spi_SCK_one
label_right_signal  const_5	zero	UART_Rx_zero
label_right_signal  const_5	one	UART_Rx_one
label_right_signal  const_6	zero	UART_Tx_zero
label_right_signal  const_6	one	UART_Tx_one
label_left_signal   const_36	zero	flash_io2_zero
label_left_signal   const_36	one	flash_io2_one
label_left_signal   const_37	zero	flash_io3_zero
label_left_signal   const_37	one	flash_io3_one

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

