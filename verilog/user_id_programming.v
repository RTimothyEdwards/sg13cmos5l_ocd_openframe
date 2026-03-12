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

`default_nettype none
// This module represents an unprogrammed mask revision
// block that is configured with via programming on the
// chip top level.  This value is passed to the block as
// a parameter

module user_id_programming #(
    parameter USER_PROJECT_ID = 32'h0
) (
`ifdef USE_POWER_PINS
    inout VDD,
    inout VSS,
`endif
    output wire [31:0] mask_rev
);
    wire [31:0] user_proj_id_high;
    wire [31:0] user_proj_id_low;

    // For the mask revision input, use an array of digital constant logic cells
    // These must be manually placed in pairs, always in the same order.

    sg13cmos5l_tiehi mask_rev_value_one [31:0] (
`ifdef USE_POWER_PINS
	    .power(VDD),
	    .ground(VSS),
`endif
            .L_HI(user_proj_id_high)
    );

    sg13cmos5l_tielo mask_rev_value_zero [31:0] (
    `ifdef USE_POWER_PINS
	    .power(VDD),
	    .ground(VSS),
    `endif
            .L_LO(user_proj_id_low)
    );

    /* Replacing the assignment with a hard-coded connection
     * until netgen can be made to understand the RHS expression
     * as structural verilog.
     */
    // genvar i;
    // generate
    //	for (i = 0; i < 32; i = i+1) begin
    //	    assign mask_rev[i] = (USER_PROJECT_ID & (32'h01 << i)) ?
    //		user_proj_id_high[i] : user_proj_id_low[i];
    //	end
    // endgenerate

    assign mask_rev = user_proj_id_low;

`ifdef LVS
    /* Enumerate the decap cells for LVS only */

    sg13cmos5l_decap_4 user_id_decap [23:0] (
    `ifdef USE_POWER_PINS
            .power(VDD),
            .ground(VSS)
    `endif
    );
`endif

endmodule
`default_nettype wire
