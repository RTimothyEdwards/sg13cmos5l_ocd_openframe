// SPDX-FileCopyrightText: 2026 Open Circuit Design, LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

/*
 *-------------------------------------------------------------------------
 * sg13cmos5l_caravel_openframe ---
 *
 * RTL verilog definition of the chip top level (pre-fill)
 *
 * This is a version of the Caravel harness chip, IHP SG13CMOS5L process,
 * dual voltage (1.8V core, 3.3V pad) padframe.
 *
 * Written by Tim Edwards
 * March 2026
 *
 * To do:  This file should be automatically generated from the project
 * wrapper and padframe.
 *-------------------------------------------------------------------------
 */

// `default_nettype none

// There are 44 GPIO pads in the openframe definition.  This
// is fixed and corresponds to the standard pinout and
// packaging for the Caravel harness chip.

`define OPENFRAME_IO_PADS 44

module sg13cmos5l_caravel_openframe (
	`ifdef USE_POWER_PINS
		// Power buses
		inout  vddio,	// Core 5.0V supply
		inout  vssio,	// Core 5.0V ground
		inout  vccd,	// Core 3.3V supply
		inout  vssd,	// Core 3.3V ground
	`endif

	// Pad pins (these are fixed)
	input  resetb,		// Master reset input pad (sense negative)
	input  option,		// Downbond option input pad
	inout  [`OPENFRAME_IO_PADS - 1:0] gpio	// General-purpose I/O
);

	/* Declare pin wires */

	wire  resetb;
	wire  option;
	wire  [`OPENFRAME_IO_PADS - 1:0] gpio;

	/* Declare signals between the project wrapper and padframe */

	wire  flash_csb_out;
	wire  flash_csb_ena;
	wire  flash_csb_in;
	wire  flash_csb_zero;
	wire  flash_csb_one;

	wire  flash_clk_out;
	wire  flash_clk_ena;
	wire  flash_clk_in;
	wire  flash_clk_zero;
	wire  flash_clk_one;

	wire  flash_io0_out;
	wire  flash_io0_ena;
	wire  flash_io0_in;
	wire  flash_io0_zero;
	wire  flash_io0_one;

	wire  flash_io1_out;
	wire  flash_io1_ena;
	wire  flash_io1_in;
	wire  flash_io1_zero;
	wire  flash_io1_one;

	wire  gpio0_out;
	wire  gpio0_ena;
	wire  gpio0_in;
	wire  gpio0_zero;
	wire  gpio0_one;

	wire  [31:0] mask_rev;

	wire  gpio1_out;
	wire  gpio1_ena;
	wire  gpio1_in;
	wire  gpio1_zero;
	wire  gpio1_one;

	wire  spi_SDO_out;
	wire  spi_SDO_ena;
	wire  spi_SDO_in;
	wire  spi_SDO_zero;
	wire  spi_SDO_one;

	wire  spi_SDI_out;
	wire  spi_SDI_ena;
	wire  spi_SDI_in;
	wire  spi_SDI_zero;
	wire  spi_SDI_one;

	wire  spi_CSB_out;
	wire  spi_CSB_ena;
	wire  spi_CSB_in;
	wire  spi_CSB_zero;
	wire  spi_CSB_one;

	wire  spi_SCK_out;
	wire  spi_SCK_ena;
	wire  spi_SCK_in;
	wire  spi_SCK_zero;
	wire  spi_SCK_one;

	wire  UART_Rx_out;
	wire  UART_Rx_ena;
	wire  UART_Rx_in;
	wire  UART_Rx_zero;
	wire  UART_Rx_one;

	wire  UART_Tx_out;
	wire  UART_Tx_ena;
	wire  UART_Tx_in;
	wire  UART_Tx_zero;
	wire  UART_Tx_one;

	wire [28:0] analog_io;
	wire [28:0] analog_io_esd;

	wire  option_in;
		
	wire  flash_io2_out;
	wire  flash_io2_ena;
	wire  flash_io2_in;
	wire  flash_io2_zero;
	wire  flash_io2_one;

	wire  flash_io3_out;
	wire  flash_io3_ena;
	wire  flash_io3_in;
	wire  flash_io3_zero;
	wire  flash_io3_one;

	/* Instantiate the project wrapper */

	openframe_project_wrapper project_wrapper (
	    `ifdef USE_POWER_PINS
		// Power buses
		.vddio(vddio),	// Core 5.0V supply
		.vssio(vssio),	// Core 5.0V ground
		.vccd(vccd),	// Core 3.3V supply
		.vssd(vssd),	// Core 3.3V ground
	    `endif

		// Core infrastructure (padframe-facing pins)
		.resetb_in(resetb_in),
		.clock_in(clock_in),

		.flash_csb_out(flash_csb_out),
		.flash_csb_ena(flash_csb_ena),
		.flash_csb_in(flash_csb_in),
		.flash_csb_zero(flash_csb_zero),
		.flash_csb_one(flash_csb_one),

		.flash_clk_out(flash_clk_out),
		.flash_clk_ena(flash_clk_ena),
		.flash_clk_in(flash_clk_in),
		.flash_clk_zero(flash_clk_zero),
		.flash_clk_one(flash_clk_one),

		.flash_io0_out(flash_io0_out),
		.flash_io0_ena(flash_io0_ena),
		.flash_io0_in(flash_io0_in),
		.flash_io0_zero(flash_io0_zero),
		.flash_io0_one(flash_io0_one),

		.flash_io1_out(flash_io1_out),
		.flash_io1_ena(flash_io1_ena),
		.flash_io1_in(flash_io1_in),
		.flash_io1_zero(flash_io1_zero),
		.flash_io1_one(flash_io1_one),
	
		.gpio0_out(gpio0_out),
		.gpio0_ena(gpio0_ena),
		.gpio0_in(gpio0_in),
		.gpio0_zero(gpio0_zero),
		.gpio0_one(gpio0_one),

		.mask_rev(mask_rev),
	
		.gpio1_out(gpio1_out),
		.gpio1_ena(gpio1_ena),
		.gpio1_in(gpio1_in),
		.gpio1_zero(gpio1_zero),
		.gpio1_one(gpio1_one),

		.spi_SDO_out(spi_SDO_out),
		.spi_SDO_ena(spi_SDO_ena),
		.spi_SDO_in(spi_SDO_in),
		.spi_SDO_zero(spi_SDO_zero),
		.spi_SDO_one(spi_SDO_one),

		.spi_SDI_out(spi_SDI_out),
		.spi_SDI_ena(spi_SDI_ena),
		.spi_SDI_in(spi_SDI_in),
		.spi_SDI_zero(spi_SDI_zero),
		.spi_SDI_one(spi_SDI_one),

		.spi_CSB_out(spi_CSB_out),
		.spi_CSB_ena(spi_CSB_ena),
		.spi_CSB_in(spi_CSB_in),
		.spi_CSB_zero(spi_CSB_zero),
		.spi_CSB_one(spi_CSB_one),

		.spi_SCK_out(spi_SCK_out),
		.spi_SCK_ena(spi_SCK_ena),
		.spi_SCK_in(spi_SCK_in),
		.spi_SCK_zero(spi_SCK_zero),
		.spi_SCK_one(spi_SCK_one),

		.UART_Rx_out(UART_Rx_out),
		.UART_Rx_ena(UART_Rx_ena),
		.UART_Rx_in(UART_Rx_in),
		.UART_Rx_zero(UART_Rx_zero),
		.UART_Rx_one(UART_Rx_one),

		.UART_Tx_out(UART_Tx_out),
		.UART_Tx_ena(UART_Tx_ena),
		.UART_Tx_in(UART_Tx_in),
		.UART_Tx_zero(UART_Tx_zero),
		.UART_Tx_one(UART_Tx_one),

		.analog_io(analog_io),
		.analog_io_esd(analog_io_esd),

		.option_in(option_in),
		
		.flash_io2_out(flash_io2_out),
		.flash_io2_ena(flash_io2_ena),
		.flash_io2_in(flash_io2_in),
		.flash_io2_zero(flash_io2_zero),
		.flash_io2_one(flash_io2_one),

		.flash_io3_out(flash_io3_out),
		.flash_io3_ena(flash_io3_ena),
		.flash_io3_in(flash_io3_in),
		.flash_io3_zero(flash_io3_zero),
		.flash_io3_one(flash_io3_one)
	);

	/* Instantiate the padframe */

	sg13cmos5l_padframe padframe(
	    `ifdef USE_POWER_PINS
		// Power buses
		.vddio(vddio),	// Core 5.0V supply
		.vssio(vssio),	// Core 5.0V ground
		.vccd(vccd),	// Core 3.3V supply
		.vssd(vssd),	// Core 3.3V ground
	    `endif

		// Pads (other than power/ground)
		.resetb(resetb),	// Master reset input pad (sense negative)
		.option(option),	// Downbond option input pad
		.gpio(gpio),	// General-purpose I/O

		// Core infrastructure (core-facing pins)
		.resetb_in(resetb_in),
		.clock_in(clock_in),

		.flash_csb_out(flash_csb_out),
		.flash_csb_ena(flash_csb_ena),
		.flash_csb_in(flash_csb_in),
		.flash_csb_zero(flash_csb_zero),
		.flash_csb_one(flash_csb_one),

		.flash_clk_out(flash_clk_out),
		.flash_clk_ena(flash_clk_ena),
		.flash_clk_in(flash_clk_in),
		.flash_clk_zero(flash_clk_zero),
		.flash_clk_one(flash_clk_one),

		.flash_io0_out(flash_io0_out),
		.flash_io0_ena(flash_io0_ena),
		.flash_io0_in(flash_io0_in),
		.flash_io0_zero(flash_io0_zero),
		.flash_io0_one(flash_io0_one),

		.flash_io1_out(flash_io1_out),
		.flash_io1_ena(flash_io1_ena),
		.flash_io1_in(flash_io1_in),
		.flash_io1_zero(flash_io1_zero),
		.flash_io1_one(flash_io1_one),
	
		.gpio0_out(gpio0_out),
		.gpio0_ena(gpio0_ena),
		.gpio0_in(gpio0_in),
		.gpio0_zero(gpio0_zero),
		.gpio0_one(gpio0_one),

		.mask_rev(mask_rev),
	
		.gpio1_out(gpio1_out),
		.gpio1_ena(gpio1_ena),
		.gpio1_in(gpio1_in),
		.gpio1_zero(gpio1_zero),
		.gpio1_one(gpio1_one),

		.spi_SDO_out(spi_SDO_out),
		.spi_SDO_ena(spi_SDO_ena),
		.spi_SDO_in(spi_SDO_in),
		.spi_SDO_zero(spi_SDO_zero),
		.spi_SDO_one(spi_SDO_one),

		.spi_SDI_out(spi_SDI_out),
		.spi_SDI_ena(spi_SDI_ena),
		.spi_SDI_in(spi_SDI_in),
		.spi_SDI_zero(spi_SDI_zero),
		.spi_SDI_one(spi_SDI_one),

		.spi_CSB_out(spi_CSB_out),
		.spi_CSB_ena(spi_CSB_ena),
		.spi_CSB_in(spi_CSB_in),
		.spi_CSB_zero(spi_CSB_zero),
		.spi_CSB_one(spi_CSB_one),

		.spi_SCK_out(spi_SCK_out),
		.spi_SCK_ena(spi_SCK_ena),
		.spi_SCK_in(spi_SCK_in),
		.spi_SCK_zero(spi_SCK_zero),
		.spi_SCK_one(spi_SCK_one),

		.UART_Rx_out(UART_Rx_out),
		.UART_Rx_ena(UART_Rx_ena),
		.UART_Rx_in(UART_Rx_in),
		.UART_Rx_zero(UART_Rx_zero),
		.UART_Rx_one(UART_Rx_one),

		.UART_Tx_out(UART_Tx_out),
		.UART_Tx_ena(UART_Tx_ena),
		.UART_Tx_in(UART_Tx_in),
		.UART_Tx_zero(UART_Tx_zero),
		.UART_Tx_one(UART_Tx_one),

		.analog_io(analog_io),
		.analog_io_esd(analog_io_esd),

		.option_in(option_in),
		
		.flash_io2_out(flash_io2_out),
		.flash_io2_ena(flash_io2_ena),
		.flash_io2_in(flash_io2_in),
		.flash_io2_zero(flash_io2_zero),
		.flash_io2_one(flash_io2_one),

		.flash_io3_out(flash_io3_out),
		.flash_io3_ena(flash_io3_ena),
		.flash_io3_in(flash_io3_in),
		.flash_io3_zero(flash_io3_zero),
		.flash_io3_one(flash_io3_one)
	);

endmodule
// `default_nettype wire
