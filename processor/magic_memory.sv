/*
 * Magic memory
 */
module magic_memory
(
    input clk,

    /* Port A */
    input read,
    input write,
    input logic [31:0] address,
    input logic [255:0] wdata,
    output logic resp,
    output logic [255:0] rdata
);

timeunit 1ns;
timeprecision 1ns;

logic [255:0] mem [2**(22)]; //only get fraction of 4GB addressable space due to modelsim limits
logic [21:0] internal_address;

/* Initialize memory contents from memory.lst file */
initial
begin
    $readmemh("memory.lst", mem);
end

/* Calculate internal address */
assign internal_address = address[26:5]; // Bottom bits are for byte addressability, don't need

/* Read */
always_comb
begin : mem_read
	rdata = mem[internal_address];
end : mem_read

/* Write */
always @(posedge clk)
begin : mem_write
    if (write)
    begin
    	mem[internal_address] = wdata;
    end
end : mem_write

/* Magic memory responds immediately */
assign resp = read | write;

endmodule : magic_memory
