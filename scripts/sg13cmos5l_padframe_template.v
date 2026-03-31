/*-----------------------------------------------------------------------*/
/* sg13cmos5l_padframe:  A 64-pad frame compatible with Efabless Caravel */
/*									 */
/* Written by:								 */
/* Tim Edwards								 */
/* Open Circuit Design, LLC						 */
/* February 2026							 */
/*-----------------------------------------------------------------------*/

TEMPLATE_MESSAGE

`default_nettype none

module sg13cmos5l_padframe (
`ifdef USE_POWER_PINS
    // Pad power connections
    inout wire vccd,
    inout wire vssd,
    inout wire vddio,
    inout wire vssio,
`endif	/* USE_POWER_PINS */

    // Pad signal connections
    inout wire [43:0] gpio,
    input wire resetb,
    input wire clock,
    input wire option,

    // Core signal connections
    INPUT_OUTPUT_LIST

    // Core signal connections:  User ID ROM
    output wire [31:0] mask_rev
);

    // Instantiate the pads:

    // Corner pads

    sg13cmos5l_Corner corner_sw (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    sg13cmos5l_Corner corner_se (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    sg13cmos5l_Corner corner_nw (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    sg13cmos5l_Corner corner_ne (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    // Bottom side pads

    sg13cmos5l_IOPadVdd pad_vccd_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    sg13cmos5l_IOPadVss pad_vssio_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    sg13cmos5l_IOPadIn pad_resetb (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(resetb),
	.p2c(resetb_in)
    );

    PAD_38_TYPE pad_gpio_38 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[38]),
	PAD_38_SIGNALS
    );

    sg13cmos5l_IOPadVss pad_vssd_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    PAD_39_TYPE pad_gpio_39 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[39]),
	PAD_39_SIGNALS
    );

    PAD_40_TYPE pad_gpio_40 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[40]),
	PAD_40_SIGNALS
    );

    PAD_41_TYPE pad_gpio_41 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[41]),
	PAD_41_SIGNALS
    );

    PAD_42_TYPE pad_gpio_42 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[42]),
	PAD_42_SIGNALS
    );

    PAD_43_TYPE pad_gpio_43 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[43]),
	PAD_43_SIGNALS
    );

    sg13cmos5l_IOPadIOVss pad_vssio_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    sg13cmos5l_IOPadIOVdd pad_vddio_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    // Right side pads

    PAD_0_TYPE pad_gpio_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[0]),
	PAD_0_SIGNALS
    );

    PAD_1_TYPE pad_gpio_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[1]),
	PAD_1_SIGNALS
    );

    PAD_2_TYPE pad_gpio_2 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[2]),
	PAD_2_SIGNALS
    );

    PAD_3_TYPE pad_gpio_3 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[3]),
	PAD_3_SIGNALS
    );

    PAD_4_TYPE pad_gpio_4 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[4]),
	PAD_4_SIGNALS
    );

    PAD_5_TYPE pad_gpio_5 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[5]),
	PAD_5_SIGNALS
    );

    PAD_6_TYPE pad_gpio_6 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[6]),
	PAD_6_SIGNALS
    );

    sg13cmos5l_IOPadIOVss pad_vssio_2 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    sg13cmos5l_IOPadVss pad_vssd_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    sg13cmos5l_IOPadIOVdd pad_vddio_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    PAD_7_TYPE pad_gpio_7 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[7]),
	PAD_7_SIGNALS
    );

    PAD_8_TYPE pad_gpio_8 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[8]),
	PAD_8_SIGNALS
    );

    PAD_9_TYPE pad_gpio_9 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[9]),
	PAD_9_SIGNALS
    );

    PAD_10_TYPE pad_gpio_10 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[10]),
	PAD_10_SIGNALS
    );

    PAD_11_TYPE pad_gpio_11 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[11]),
	PAD_11_SIGNALS
    );

    PAD_12_TYPE pad_gpio_12 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[12]),
	PAD_12_SIGNALS
    );

    sg13cmos5l_IOPadIOVdd pad_vddio_2 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    PAD_13_TYPE pad_gpio_13 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[13]),
	PAD_13_SIGNALS
    );

    sg13cmos5l_IOPadVdd pad_vccd_1 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    PAD_14_TYPE pad_gpio_14 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[14]),
	PAD_14_SIGNALS
    );

    // Top side pads

    PAD_15_TYPE pad_gpio_15 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[15]),
	PAD_15_SIGNALS
    );

    sg13cmos5l_IOPadIOVss pad_vssio_3 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    PAD_16_TYPE pad_gpio_16 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[16]),
	PAD_16_SIGNALS
    );

    PAD_17_TYPE pad_gpio_17 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[17]),
	PAD_17_SIGNALS
    );

    PAD_18_TYPE pad_gpio_18 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[18]),
	PAD_18_SIGNALS
    );

    sg13cmos5l_IOPadIOVss pad_vssio_4 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    PAD_19_TYPE pad_gpio_19 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[19]),
	PAD_19_SIGNALS
    );

    PAD_20_TYPE pad_gpio_20 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[20]),
	PAD_20_SIGNALS
    );

    PAD_21_TYPE pad_gpio_21 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[21]),
	PAD_21_SIGNALS
    );

    PAD_22_TYPE pad_gpio_22 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[22]),
	PAD_22_SIGNALS
    );

    PAD_23_TYPE pad_gpio_23 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[23]),
	PAD_23_SIGNALS
    );

    sg13cmos5l_IOPadIn pad_option_0 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(option),
	.p2c(option_in)
    );

    // Right side pads

    PAD_24_TYPE pad_gpio_24 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[24]),
	PAD_24_SIGNALS
    );

    sg13cmos5l_IOPadVdd pad_vccd_2 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    sg13cmos5l_IOPadIOVdd pad_vddio_3 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    sg13cmos5l_IOPadIOVss pad_vssio_5 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    PAD_25_TYPE pad_gpio_25 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[25]),
	PAD_25_SIGNALS
    );

    PAD_26_TYPE pad_gpio_26 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[26]),
	PAD_26_SIGNALS
    );

    PAD_27_TYPE pad_gpio_27 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[27]),
	PAD_27_SIGNALS
    );

    PAD_28_TYPE pad_gpio_28 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[28]),
	PAD_28_SIGNALS
    );

    PAD_29_TYPE pad_gpio_29 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[29]),
	PAD_29_SIGNALS
    );

    PAD_30_TYPE pad_gpio_30 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[30]),
	PAD_30_SIGNALS
    );

    PAD_31_TYPE pad_gpio_31 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[31]),
	PAD_31_SIGNALS
    );

    sg13cmos5l_IOPadIOVdd pad_vddio_4 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    sg13cmos5l_IOPadVss pad_vssd_2 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    PAD_32_TYPE pad_gpio_32 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[32]),
	PAD_32_SIGNALS
    );

    PAD_33_TYPE pad_gpio_33 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[33]),
	PAD_33_SIGNALS
    );

    PAD_34_TYPE pad_gpio_34 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[34]),
	PAD_34_SIGNALS
    );

    PAD_35_TYPE pad_gpio_35 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[35]),
	PAD_35_SIGNALS
    );

    PAD_36_TYPE pad_gpio_36 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[36]),
	PAD_36_SIGNALS
    );

    PAD_37_TYPE pad_gpio_37 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd),
	`endif	/* USE_POWER_PINS */
	.pad(gpio[37]),
	PAD_37_SIGNALS
    );

    sg13cmos5l_IOPadIOVdd pad_vddio_5 (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    /* Filler pads between each bond pad */

    sg13cmos5l_Filler10000 spacer [59:0] (
	`ifdef USE_POWER_PINS
	    .iovdd(vddio),
	    .iovss(vssio),
	    .vdd(vccd),
	    .vss(vssd)
	`endif	/* USE_POWER_PINS */
    );

    /* Non-electrically-connected modules */

    caravel_logo caravel_logo ();
    caravel_motto caravel_motto ();
    copyright_block copyright_block ();
    user_id_textblock user_id_textblock ();
    open_source open_source ();

    /* Add in user_id_programming (32-bit ROM block) */

    user_id_programming user_id_programming (
	`ifdef USE_POWER_PINS
	    .VDD(vccd),
	    .VSS(vssd),
	`endif  /* USE_POWER_PINS */
	.mask_rev(mask_rev)
    );

    /* Add in constant blocks (digital 1/0 near each digital pad) */

   CONSTANT_BLOCKS

endmodule

`default_nettype wire
