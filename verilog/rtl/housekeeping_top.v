/*
 * Module which instantiates the housekeeping unit along with
 * antenna tie-downs on all inputs and buffers on all outputs.
 */

module housekeeping_top (
`ifdef USE_POWER_PINS
    VPWR, VGND,
`endif
    RSTB, SCK, SDI, CSB, SDO, sdo_ena,
    reset, mask_rev_in,
    control, status
);

`ifdef USE_POWER_PINS
    inout VPWR;     // 1.8V supply
    inout VGND;     // common ground
`endif

    input RSTB;     // from padframe
    input SCK;      // from padframe
    input SDI;      // from padframe
    input CSB;      // from padframe
    output SDO;     // to padframe
    output sdo_ena; // to padframe
    output [127:0] control;     // to project
    input [127:0]  status;      // from project

    output reset;
    input [31:0] mask_rev_in;   // metal programmed;  3.3V domain

    wire [127:0] control_unbuf;

    // NOTE:  IHP verilog for the standard cells does not have power and ground

    /* Instantiate antenna tie-downs on all status pins */
    (* keep *)
    sg13cmos5l_antennanp tiedowns [127:0] (
	`ifdef USE_POWER_PINS
	    // .VDD(VPWR),
	    // .VSS(VGND),
	`endif
	.A(status)
    );
    
    /* Instantiate buffers on all outputs */
    (* keep *)
    sg13cmos5l_buf_8 outbuffers [127:0] (
	`ifdef USE_POWER_PINS
	    // .VDD(VPWR),
	    // .VSS(VGND),
	`endif
	.A(control_unbuf),
	.X(control)
    );

    /* Instantiate the housekeeping module */
    housekeeping hk (
	`ifdef USE_POWER_PINS
	    .VPWR(VPWR),
	    .VGND(VGND),
	`endif
	    .RSTB(RSTB),
	    .SCK(SCK),
	    .SDI(SDI),
	    .CSB(CSB),
	    .SDO(SDO),
	    .sdo_ena(sdo_ena),
	    .reset(reset),
	    .mask_rev_in(mask_rev_in),
	    .control(control_unbuf),
	    .status(status)
    );

endmodule
