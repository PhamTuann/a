module sent_rx_top
	#(parameter ADDRESSWIDTH= 5,
	parameter DATAWIDTH= 16)
	(
	input clk_rx,
	input sent_rx_i,
	input PCLK_rx,
	input PRESETn_rx,
	input [ADDRESSWIDTH-1:0]PADDR_rx_i,
	input PWRITE_rx_i,
	input PSELx_rx_i,
	input PENABLE_rx_i,
	output [DATAWIDTH-1:0] PRDATA_rx_o,
	output PREADY_rx_o
	);
	
	//----------SENT RX------------------//
	//pulse check block <-> crc check block
	wire [29:0] data_check_crc_io;

	//pulse check block <-> store fifo
	wire [11:0] data_out;
	wire write_enable_store_io;
	wire start_io;
	//pulse check block <-> rx control
	wire [2:0] done_pre_data_io;
	wire [7:0] id_decode_io;
	wire [15:0] data_decode_io;
	wire [1:0] channel_format_decode_io;
	wire pause_decode_io;
	wire config_bit_decode_io;

	//rx control <-> store fifo
	wire [11:0] data_fast_in;
	wire read_enable_store_io;

	//rx control <-> crc check
	wire [2:0] enable_crc_check_io;
	wire valid_data_serial_io;
	wire valid_data_enhanced_io;
	wire valid_data_fast_io;
	wire crc_check_done_io;

	wire [15:0] reg_receive_rx;		//READ ONLY
	wire [15:0] reg_id_rx;			//READ ONLY
	wire [15:0] reg_data_field_rx; 		//READ ONLY
	wire [15:0] reg_status_rx;
	wire [15:0] reg_command_rx;
	wire [11:0] data_fast_out;
	wire read_enable_rx;
	
	sent_rx_pulse_decode sent_rx_pulse_decode(
		.clk_rx(clk_rx),
		.reset_n_rx(PRESETn_rx),
		.sent_rx_i(sent_rx_i),
		.data_check_crc_o(data_check_crc_io),
		.done_pre_data_o(done_pre_data_io),
		.id_decode_o(id_decode_io),
		.data_decode_o(data_decode_io),
		.write_enable_store_o(write_enable_store_io),
		.data_o(data_out),
		.channel_format_decode_o(channel_format_decode_io),
		.pause_decode_o(pause_decode_io),
		.config_bit_decode_o(config_bit_decode_io),
		.start_o(start_io)
	);

	async_fifo store_fifo(
		.write_enable(write_enable_store_io), 
		.write_clk(clk_rx), 
		.write_reset_n(PRESETn_rx),
		.read_enable(read_enable_store_io), 
		.read_clk(clk_rx), 
		.read_reset_n(PRESETn_rx),
		.write_data(data_out),
		.read_data(data_fast_in),
		.write_full(write_full),
		.read_empty(read_empty)
	);

	sent_rx_crc_check sent_rx_crc_check(
		.clk_rx(clk_rx),
		.reset_n_rx(PRESETn_rx),
		//signals to control block
		.enable_crc_check_i(enable_crc_check_io),
		.data_check_crc_i(data_check_crc_io),
		.valid_data_serial_o(valid_data_serial_io),
		.valid_data_enhanced_o(valid_data_enhanced_io),
		.valid_data_fast_o(valid_data_fast_io),
		.crc_check_done_o(crc_check_done_io)

	);
	
	sent_rx_control sent_rx_control(
		.clk_rx(clk_rx),
		.reset_n_rx(PRESETn_rx),
		.done_pre_data_i(done_pre_data_io),
		.enable_crc_check_o(enable_crc_check_io),
		.valid_data_serial_i(valid_data_serial_io),
		.valid_data_enhanced_i(valid_data_enhanced_io),
		.valid_data_fast_i(valid_data_fast_io),
		.id_decode_i(id_decode_io),
		.pause_decode_i(pause_decode_io),
		.config_bit_decode_i(config_bit_decode_io),
		.channel_format_decode_i(channel_format_decode_io),
		.data_decode_i(data_decode_io),
		.read_enable_store_o(read_enable_store_io),
		.data_i(data_fast_in),
		.write_enable_rx_o(write_enable_rx_io),
		.data_fast_o(data_fast_out),
		.id_received_o(reg_id_rx[7:0]),
		.data_received_o(reg_data_field_rx),
		.channel_format_received_o(reg_command_rx[7]),
		.pause_received_o(reg_command_rx[6]),
		.config_bit_received_o(reg_command_rx[5]),
		.crc_check_done_i(crc_check_done_io),
		.start_i(start_io)
	);

	async_fifo rx_fifo(
		.write_enable(write_enable_rx_io), 
		.write_clk(clk_rx), 
		.write_reset_n(PRESETn_rx),
		.read_enable(read_enable_rx), 
		.read_clk(PCLK_rx), 
		.read_reset_n(PRESETn_rx),
		.write_data(data_fast_out),
		.read_data(reg_receive_rx[11:0]),
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
