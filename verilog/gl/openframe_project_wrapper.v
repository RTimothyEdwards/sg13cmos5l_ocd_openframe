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
 * openframe_project_wrapper ---
 *
 * RTL verilog definition of the user project area for the open-frame
 * version of the Caravel harness chip, IHP SG13CMOS5L process, dual voltage
 * (1.8V core, 3.3V pad) padframe.
 *
 * Written by Tim Edwards
 * February 2026
 *
 * To do:  This file should be automatically generated from the project
 * pin list.
 *-------------------------------------------------------------------------
 */

// `default_nettype none

// There are 44 GPIO pads in the openframe definition.  This
// is fixed and corresponds to the standard pinout and
// packaging for the Caravel harness chip.

`define OPENFRAME_IO_PADS 44

module openframe_project_wrapper (
	`ifdef USE_POWER_PINS
		// Power buses
		inout  vddio,	// Core 5.0V supply
		inout  vssio,	// Core 5.0V ground
		inout  vccd,	// Core 3.3V supply
		inout  vssd,	// Core 3.3V ground
	`endif

	// Core infrastructure (padframe-facing pins)
	input  resetb_in,
	input  clock_in,

	input  flash_csb_out,
	input  flash_csb_ena,
	input  flash_csb_in,
	input  flash_csb_zero,
	input  flash_csb_one,

	input  flash_clk_out,
	input  flash_clk_ena,
	input  flash_clk_in,
	input  flash_clk_zero,
	input  flash_clk_one,

	input  flash_io0_out,
	input  flash_io0_ena,
	input  flash_io0_in,
	input  flash_io0_zero,
	input  flash_io0_one,

	input  flash_io1_out,
	input  flash_io1_ena,
	input  flash_io1_in,
	input  flash_io1_zero,
	input  flash_io1_one,

	input  gpio0_out,
	input  gpio0_ena,
	input  gpio0_in,
	input  gpio0_zero,
	input  gpio0_one,

	input  [31:0] mask_rev,

	input  gpio1_out,
	input  gpio1_ena,
	input  gpio1_in,
	input  gpio1_zero,
	input  gpio1_one,

	input  spi_SDO_out,
	input  spi_SDO_ena,
	input  spi_SDO_in,
	input  spi_SDO_zero,
	input  spi_SDO_one,

	input  spi_SDI_out,
	input  spi_SDI_ena,
	input  spi_SDI_in,
	input  spi_SDI_zero,
	input  spi_SDI_one,

	input  spi_CSB_out,
	input  spi_CSB_ena,
	input  spi_CSB_in,
	input  spi_CSB_zero,
	input  spi_CSB_one,

	input  spi_SCK_out,
	input  spi_SCK_ena,
	input  spi_SCK_in,
	input  spi_SCK_zero,
	input  spi_SCK_one,

	input  UART_Rx_out,
	input  UART_Rx_ena,
	input  UART_Rx_in,
	input  UART_Rx_zero,
	input  UART_Rx_one,

	input  UART_Tx_out,
	input  UART_Tx_ena,
	input  UART_Tx_in,
	input  UART_Tx_zero,
	input  UART_Tx_one,

	inout	[28:0] analog_io,
	inout	[28:0] analog_io_esd,

	input  option_in,
		
	input  flash_io2_out,
	input  flash_io2_ena,
	input  flash_io2_in,
	input  flash_io2_zero,
	input  flash_io2_one,

	input  flash_io3_out,
	input  flash_io3_ena,
	input  flash_io3_in,
	input  flash_io3_zero,
	input  flash_io3_one
);

	// Declare a user project by defining HAS_USER_PROJECT
	// and specifying the "netlists.v" file to include the
	// RTL source code for it.

	`ifdef HAS_USER_PROJECT
	    openframe_user_project user_project (
		`ifdef USE_POWER_PINS
		    // Power buses
		    .vddio(vddio),	// Core 5.0V supply
		    .vssio(vssio),	// Core 5.0V ground
		    .vccd(vccd),	// Core 3.3V supply
		    .vssd(vssd),	// Core 3.3V ground
		`endif

		// Core infrastructure
		.mask_rev(mask_rev),
		
		// User project IOs
		.gpio1_out(gpio1_zero),
		.gpio1_ena(gpio1_zero),
		.gpio1_in(gpio1_in),
		.gpio1_zero(gpio1_zero),

		.spi_SDO_out(spi_SDO_out),
		.spi_SDO_ena(spi_SDO_ena),
		.spi_SDO_zero(spi_SDO_zero),
		.spi_SDO_one(spi_SDO_zero),

		.spi_SDI_out(spi_SDI_zero),
		.spi_SDI_ena(spi_SDI_zero),
		.spi_SDI_in(spi_SDI_in),
		.spi_SDI_zero(spi_SDI_zero),

		.spi_CSB_out(spi_CSB_zero),
		.spi_CSB_ena(spi_CSB_zero),
		.spi_CSB_in(spi_CSB_in),
		.spi_CSB_zero(spi_CSB_zero),

		.spi_SCK_out(spi_SCK_zero),
		.spi_SCK_ena(spi_SCK_zero),
		.spi_SCK_in(spi_SCK_in),
		.spi_SCK_zero(spi_SCK_zero),

		.UART_Rx_out(UART_Rx_zero),
		.UART_Rx_ena(UART_Rx_zero),
		.UART_Rx_zero(UART_Rx_zero),

		.UART_Tx_out(UART_Tx_zero),
		.UART_Tx_ena(UART_Tx_zero),
		.UART_Tx_zero(UART_Tx_zero),

		.vbg(analog_io[0]),
		.ref_in(analog_io[1]),
		.idac2_sink(analog_io[18]),
		.test_source(analog_io[20]),
		.idac1_sink(analog_io[21]),
		.voltgen_vout1(analog_io[22]),
		.voltgen_vout2(analog_io[23]),
		.idac1_source(analog_io[24]),
		.idac2_source(analog_io[25]),
		.test_source_ibias(analog_io[27]),

		.flash_io3_one(flash_io3_one),
		.flash_io3_zero(flash_io3_zero),

		.resetb(resetb_in)
	);
	`endif

endmodule
// `default_nettype wire
