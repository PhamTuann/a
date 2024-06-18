module sent_tx_top
	#(parameter ADDRESSWIDTH= 3,
	parameter DATAWIDTH= 16)
	(
	//clk_tx and reset_n_tx
	input clk_tx,	
	input PCLK_tx,
	input PRESETn_tx,
	input [ADDRESSWIDTH-1:0]PADDR_tx_i,
	input [DATAWIDTH-1:0] PWDATA_tx_i,
	input PWRITE_tx_i,
	input PSELx_tx_i,
	input PENABLE_tx_i,
	output [DATAWIDTH-1:0] PRDATA_tx_o,
	output PREADY_tx_o,
	output sent_tx_o
	
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

	//----------SENT TX------------------//
	//control block <-> crc block
	wire [2:0] enable_crc_gen_io;
	wire [23:0] data_gen_crc_io;
	wire [5:0] crc_gen_io;
	wire crc_gen_done_io;
	//gen ticks block <-> pulse gen block
	wire ticks_io;

	//control block <-> pulse gen block
	wire [3:0] data_nibble_io;
	wire pulse_io;
	wire sync_io;
	wire pause_io;
	wire pulse_done_io;
	wire idle_io;
	
	//data reg block <-> control block
	wire [2:0] load_bit_io;
	wire done_pre_data_io;
	wire [15:0] data_f1_io;
	wire [11:0] data_f2_io;
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

	//----------SENT TX------------------//
	
	sent_tx_data_reg sent_tx_data_reg(
		//clk_tx and reset_n_tx
		.clk_tx(clk_tx),
		.reset_n_tx(PRESETn_tx),

		//signals to control block
		.load_bit_i(load_bit_io),
		.done_pre_data_o(done_pre_data_io),
		.data_f1_o(data_f1_io),
		.data_f2_o(data_f2_io),

		//signals to fifo
		.data_fast_i(data_fast_io),
		.read_enable_tx_o(read_enable_tx_io),
		.fifo_tx_empty_i(a)
	);

	sent_tx_control sent_tx_control(
		//clk_tx and reset_n_tx
		.clk_tx(clk_tx),
		.reset_n_tx(PRESETn_tx),

		//normal input
		.channel_format_i(reg_command_tx[7:6]), //0: serial(), 1: enhanced
		.optional_pause_i(reg_command_tx[5]),
		.config_bit_i(reg_command_tx[4]),
		.enable_i(reg_command_tx[3]),
		.id_i(reg_id_tx),
		.data_bit_field_i(reg_data_field_tx),

		//signals to crc block
		.enable_crc_gen_o(enable_crc_gen_io),
		.data_gen_crc_o(data_gen_crc_io),
		.crc_gen_i(crc_gen_io),
		.crc_gen_done_i(crc_gen_done_io),
		//signals to pulse gen block
		.pulse_done_i(pulse_done_io),
		.data_nibble_o(data_nibble_io),
		.pulse_o(pulse_io),
		.sync_o(sync_io),
		.pause_o(pause_io),
		.idle_o(idle_io),
		
		//signals to data reg block
		.data_f1_i(data_f1_io),
		.data_f2_i(data_f2_io),
		.load_bit_o(load_bit_io),
		.done_pre_data_i(done_pre_data_io)
	);

	sent_tx_pulse_gen sent_tx_pulse_gen(
		.clk_tx(clk_tx),
		//clk_tx and reset_n_tx
		.ticks_i(ticks_io),
		.reset_n_tx(PRESETn_tx),

		//signals to control
		.data_nibble_i(data_nibble_io),
		.pulse_i(pulse_io),
		.sync_i(sync_io),
		.pause_i(pause_io),
		.idle_i(idle_io),
		.pulse_done_o(pulse_done_io),

		//output
		.sent_tx_o(sent_tx_o)
	);

	sent_tx_gen_ticks sent_tx_gen_ticks(
		.clk_tx(clk_tx),
		.reset_n_tx(PRESETn_tx),
		.ticks_o(ticks_io),
		.divide_i(prescale_tx)
	);

	sent_tx_crc_gen sent_tx_crc_gen(
		.clk_tx(clk_tx),
		.reset_n_tx(PRESETn_tx),
		.crc_gen_o(crc_gen_io),
		.enable_crc_gen_i(enable_crc_gen_io),
		.data_gen_crc_i(data_gen_crc_io),
		.crc_gen_done_o(crc_gen_done_io)
	);
endmodule
