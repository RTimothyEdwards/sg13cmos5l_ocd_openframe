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
 * sg13cmos5l_caravel_openframe_final ---
 *
 * RTL verilog definition of the chip top level (post-fill)
 *
 * This is a version of the Caravel harness chip, IHP SG13CMOS5L process,
 * dual voltage (1.8V core, 3.3V pad) padframe.
 *
 * Written by Tim Edwards
 * March 2026
 *
 * This file is independent of the project definition and does not change.
 * The pinouts of the pre-fill and post-fill modules are the same.  The
 * layout at this module level contains the fill pattern cell.
 *
 *-------------------------------------------------------------------------
 */

// `default_nettype none

// There are 44 GPIO pads in the openframe definition.  This
// is fixed and corresponds to the standard pinout and
// packaging for the Caravel harness chip.

`define OPENFRAME_IO_PADS 44

module sg13cmos5l_caravel_openframe_final (
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

	/* Instantiate the pre-fill chip top level */

	sg13cmos5l_caravel_openframe chip_top (
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
		.gpio(gpio)	// General-purpose I/O
	);

	/* Instantiate the fill pattern cell, which has no pins or
	 * contents.  The verilog module is a placeholder for the layout
	 * for LVS purposes.
	 */

	sg13cmos5l_caravel_openframe_fill_pattern fill_patterns ();

endmodule
// `default_nettype wire
