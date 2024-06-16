module top
	#(parameter ADDRESSWIDTH= 3,
	parameter DATAWIDTH= 18)
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
	
	//REGISTER
	wire [7:0] prescale_tx;
	wire [7:0] reg_command_tx;		//RW
	wire [11:0] reg_transmit_tx;		//RW
	wire [7:0] reg_id_tx;			//RW
	wire [15:0] reg_data_field_tx;		//RW
	wire [7:0] reg_status_tx;
	//APB <-> FIFO TX AND RX
	wire write_enable_tx;
	wire read_enable_rx;
   	wire read_enable_tx_io;
	wire [11:0] data_fast_io;
	wire data_pulse_io;
	wire write_enable_rx_io;
	wire [17:0] reg_valid_rx;
	wire [11:0] data_fast_out;

	wire [11:0] reg_receive_rx;		//READ ONLY
	wire [7:0] reg_id_rx;			//READ ONLY
	wire [15:0] reg_data_field_rx; 		//READ ONLY
	wire [7:0] reg_status_rx;
	wire [7:0] reg_command_rx;
	assign reg_command_rx[4:0] = 4'b0000;
	assign reg_status_rx[5:0] = 6'b000000;
	assign reg_status_tx[5:0] = 6'b000000;
	wire a;
	assign a = reg_status_tx[6];
	apb_tx apb_tx(
		.PCLK_tx(PCLK_tx),
		.PRESETn_tx(PRESETn_tx),
		.PADDR_tx_i(PADDR_tx_i),
		.PWDATA_tx_i(PWDATA_tx_i),
		.PWRITE_tx_i(PWRITE_tx_i),
		.PSELx_tx_i(PSELx_tx_i),
		.PENABLE_tx_i(PENABLE_tx_i),
		.PRDATA_tx_o(PRDATA_tx_o),
		.PREADY_tx_o(PREADY_tx_o),
		.reg_command_tx(reg_command_tx),  
		.reg_transmit_tx(reg_transmit_tx), 
		.reg_id_tx(reg_id_tx), 
		.reg_data_field_tx(reg_data_field_tx),
		.write_enable_tx(write_enable_tx),
		.prescale_tx(prescale_tx),
		.reg_status_tx(reg_status_tx)
	);

	async_fifo tx_fifo(
		.write_enable(write_enable_tx), 
		.write_clk(PCLK_tx), 
		.write_reset_n(PRESETn_tx),
		.read_enable(read_enable_tx_io), 
		.read_clk(clk_tx), 
		.read_reset_n(PRESETn_tx),
		.write_data(reg_transmit_tx),
		.read_data(data_fast_io),
		.write_full(reg_status_tx[7]),
		.read_empty(reg_status_tx[6])
	);
	
	sent_tx_top sent_tx_top(
	//clk and reset
		.clk_tx(clk_tx),	
		.reset_n_tx(PRESETn_tx),
		.channel_format_i(reg_command_tx[7:6]), //0: serial(), 1: enhanced
		.optional_pause_i(reg_command_tx[5]),
		.config_bit_i(reg_command_tx[4]),
		.enable_i(reg_command_tx[3]),
		.id_i(reg_id_tx),
		.data_bit_field_i(reg_data_field_tx),
		.sent_tx_o(data_pulse_io),
		.read_enable_tx_o(read_enable_tx_io),
		.data_fast_i(data_fast_io),
		.fifo_tx_empty_i(a),
		.divide_i(prescale_tx)
	);

	sent_rx_top sent_rx_top(
		.clk_rx(clk_rx),
		.reset_n_rx(PRESETn_rx),
		.sent_rx_i(data_pulse_io),
		.write_enable_rx_o(write_enable_rx_io),
		.id_received_o(reg_id_rx),
		.data_received_o(reg_data_field_rx),
		.data_fast_o(data_fast_out),
		.channel_format_received_o(reg_command_rx[7]),
		.pause_received_o(reg_command_rx[6]),
		.config_bit_received_o(reg_command_rx[5]),
		.valid_data(reg_valid_rx)
	);
	
	async_fifo rx_fifo(
		.write_enable(write_enable_rx_io), 
		.write_clk(clk_rx), 
		.write_reset_n(PRESETn_rx),
		.read_enable(read_enable_rx), 
		.read_clk(PCLK_rx), 
		.read_reset_n(PRESETn_rx),
		.write_data(data_fast_out),
		.read_data(reg_receive_rx),
		.write_full(reg_status_rx[7]),
		.read_empty(reg_status_rx[6])
	);

	apb_rx apb_rx (
		.PCLK_rx(PCLK_rx),
		.PRESETn_rx(PRESETn_rx),
		.PADDR_rx_i(PADDR_rx_i),
		.PWRITE_rx_i(PWRITE_rx_i),
		.PSELx_rx_i(PSELx_rx_i),
		.PENABLE_rx_i(PENABLE_rx_i),
		.PRDATA_rx_o(PRDATA_rx_o),
		.PREADY_rx_o(PREADY_rx_o),
		.reg_receive_rx(reg_receive_rx),		
		.reg_id_rx(reg_id_rx),			
		.reg_data_field_rx(reg_data_field_rx),		
		.reg_command_rx(reg_command_rx),				
		.reg_status_rx(reg_status_rx),
		.read_enable_rx(read_enable_rx)
	);

endmodule