module top
	#(parameter ADDRESSWIDTH= 3,
	parameter DATAWIDTH= 16)
	(
	input PCLK_tx,
	input PRESETn_tx,
	input [ADDRESSWIDTH-1:0]PADDR_tx_i,
	input [DATAWIDTH-1:0] PWDATA_tx_i,
	input PWRITE_tx_i,
	input PSELx_tx_i,
	input PENABLE_tx_i,
	output [DATAWIDTH-1:0] PRDATA_tx_o,
	output PREADY_tx_o,

	input PCLK_rx,
	input PRESETn_rx,
	input [ADDRESSWIDTH-1:0]PADDR_rx_i,
	input PWRITE_rx_i,
	input PSELx_rx_i,
	input PENABLE_rx_i,
	output [DATAWIDTH-1:0] PRDATA_rx_o,
	output PREADY_rx_o,		

	input clk_tx,
	input clk_rx
	);
	
	wire sent_tx_io;
	
	sent_tx_top sent_tx_top(
	//clk and reset
		.clk_tx(clk_tx),
		.sent_tx_o(sent_tx_io),
		.PCLK_tx(PCLK_rx),
		.PRESETn_tx(PRESETn_tx),
		.PADDR_tx_i(PADDR_tx_i),
		.PWRITE_tx_i(PWRITE_tx_i),
		.PWDATA_tx_i(PWDATA_tx_i),
		.PSELx_tx_i(PSELx_tx_i),
		.PENABLE_tx_i(PENABLE_tx_i),
		.PRDATA_tx_o(PRDATA_tx_o),
		.PREADY_tx_o(PREADY_tx_o)
	);

	sent_rx_top sent_rx_top(
		.clk_rx(clk_rx),
		.sent_rx_i(sent_tx_io),
		.PCLK_rx(PCLK_rx),
		.PRESETn_rx(PRESETn_rx),
		.PADDR_rx_i(PADDR_rx_i),
		.PWRITE_rx_i(PWRITE_rx_i),
		.PSELx_rx_i(PSELx_rx_i),
		.PENABLE_rx_i(PENABLE_rx_i),
		.PRDATA_rx_o(PRDATA_rx_o),
		.PREADY_rx_o(PREADY_rx_o)
	);

endmodule