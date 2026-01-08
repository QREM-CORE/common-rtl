/*
 * Interface Name: axis_if
 * Author:         Kiet Le
 * Description: - Protocol: AXI4-Stream (AXIS)
 *              - Features: Parameterized width; Sink/Source modports.
 */

interface axis_if #(
    parameter DWIDTH = 256,
    parameter KEEP_WIDTH = DWIDTH/8
);
    logic [DWIDTH-1:0]     tdata;
    logic                  tvalid;
    logic                  tlast;
    logic [KEEP_WIDTH-1:0] tkeep;
    logic                  tready;

    // Modport for the Sink (Input to your core)
    modport sink (
        input  tdata, tvalid, tlast, tkeep,
        output tready
    );

    // Modport for the Source (Output from your core)
    modport source (
        output tdata, tvalid, tlast, tkeep,
        input  tready
    );
endinterface
