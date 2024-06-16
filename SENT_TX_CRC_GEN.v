module sent_tx_crc_gen(
	//reset_n_tx
	input clk_tx,
	input reset_n_tx,

	//signals to control block
	input [2:0] enable_crc_gen_i,
	input [23:0] data_gen_crc_i,
	output reg [5:0] crc_gen_o,
	output reg [1:0] crc_gen_done_o
	);

	wire [5:0] lfsr_q; //current state
	reg [5:0] lfsr_c; //next state
	
	always @(*) begin
		case(enable_crc_gen_i)
			3'b001: begin //6 nibble
				lfsr_c[0] = lfsr_q[0] ^ data_gen_crc_i[22] ^ data_gen_crc_i[21] ^ data_gen_crc_i[17] ^ data_gen_crc_i[15] ^ data_gen_crc_i[14] ^ data_gen_crc_i[10] ^ data_gen_crc_i[8] ^ data_gen_crc_i[7] ^ data_gen_crc_i[3] ^ data_gen_crc_i[1] ^ data_gen_crc_i[0];
				lfsr_c[1] = lfsr_q[3] ^ data_gen_crc_i[23] ^ data_gen_crc_i[22] ^ data_gen_crc_i[18] ^ data_gen_crc_i[16] ^ data_gen_crc_i[15] ^ data_gen_crc_i[11] ^ data_gen_crc_i[9] ^ data_gen_crc_i[8] ^ data_gen_crc_i[4] ^ data_gen_crc_i[2] ^ data_gen_crc_i[1]; 
				lfsr_c[2] = lfsr_q[0] ^ lfsr_q[2] ^ data_gen_crc_i[23] ^ data_gen_crc_i[22] ^ data_gen_crc_i[21] ^ data_gen_crc_i[19] ^ data_gen_crc_i[16] ^ data_gen_crc_i[15] ^ data_gen_crc_i[14] ^ data_gen_crc_i[12] ^ data_gen_crc_i[9] ^ data_gen_crc_i[7] ^ data_gen_crc_i[5] ^ data_gen_crc_i[2] ^ data_gen_crc_i[1] ^ data_gen_crc_i[0]; 
				lfsr_c[3] =  lfsr_q[1] ^ data_gen_crc_i[23] ^ data_gen_crc_i[21] ^ data_gen_crc_i[20] ^ data_gen_crc_i[16] ^ data_gen_crc_i[14] ^ data_gen_crc_i[13] ^ data_gen_crc_i[9] ^ data_gen_crc_i[7] ^ data_gen_crc_i[6] ^ data_gen_crc_i[2] ^ data_gen_crc_i[0];
				lfsr_c[5:4] = 2'b00;
			end
			3'b100, 3'b011: begin //3 nibble + serial
				lfsr_c[0] = lfsr_q[1] ^ lfsr_q[2] ^ data_gen_crc_i[10] ^ data_gen_crc_i[8] ^ data_gen_crc_i[7] ^ data_gen_crc_i[3] ^ data_gen_crc_i[1] ^ data_gen_crc_i[0];
				lfsr_c[1] = lfsr_q[1] ^ data_gen_crc_i[11] ^ data_gen_crc_i[9] ^ data_gen_crc_i[8] ^ data_gen_crc_i[4] ^ data_gen_crc_i[2] ^ data_gen_crc_i[1];
				lfsr_c[2] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ data_gen_crc_i[9] ^ data_gen_crc_i[8] ^ data_gen_crc_i[7] ^ data_gen_crc_i[5] ^ data_gen_crc_i[2] ^ data_gen_crc_i[1] ^ data_gen_crc_i[0]; 
				lfsr_c[3] = lfsr_q[2] ^ lfsr_q[3] ^ data_gen_crc_i[9] ^ data_gen_crc_i[7] ^ data_gen_crc_i[6] ^ data_gen_crc_i[2] ^ data_gen_crc_i[0];
				lfsr_c[5:4] = 2'b00;
			end
			3'b010: begin //4 nibble
				lfsr_c[0] = lfsr_q[3] ^ data_gen_crc_i[15] ^ data_gen_crc_i[14] ^ data_gen_crc_i[10] ^ data_gen_crc_i[8] ^ data_gen_crc_i[7] ^ data_gen_crc_i[3] ^ data_gen_crc_i[1] ^ data_gen_crc_i[0];
				lfsr_c[1] = lfsr_q[0] ^ lfsr_q[2] ^ data_gen_crc_i[15] ^ data_gen_crc_i[11] ^ data_gen_crc_i[9] ^ data_gen_crc_i[8] ^ data_gen_crc_i[4] ^ data_gen_crc_i[2] ^ data_gen_crc_i[1];
				lfsr_c[2] = lfsr_q[0] ^ lfsr_q[1] ^ data_gen_crc_i[15] ^ data_gen_crc_i[14] ^ data_gen_crc_i[12] ^ data_gen_crc_i[9] ^ data_gen_crc_i[8] ^ data_gen_crc_i[7] ^ data_gen_crc_i[5] ^ data_gen_crc_i[2] ^ data_gen_crc_i[1] ^ data_gen_crc_i[0]; 
				lfsr_c[3] = lfsr_q[0] ^ data_gen_crc_i[15] ^ data_gen_crc_i[13] ^ data_gen_crc_i[9] ^ data_gen_crc_i[7] ^ data_gen_crc_i[6] ^ data_gen_crc_i[2] ^ data_gen_crc_i[0];
				lfsr_c[5:4] = 2'b00;
			end
			3'b101: begin //enhanced
				lfsr_c[0] = data_gen_crc_i[6] ^ data_gen_crc_i[11] ^ data_gen_crc_i[4] ^ data_gen_crc_i[16] ^ data_gen_crc_i[9] ^ data_gen_crc_i[17] ^ data_gen_crc_i[2] ^ data_gen_crc_i[14] ^ data_gen_crc_i[7] ^ lfsr_q[1] ^ data_gen_crc_i[3] ^ data_gen_crc_i[22] ^ data_gen_crc_i[15] ^ data_gen_crc_i[21] ^ data_gen_crc_i[0] ;
				lfsr_c[1] = data_gen_crc_i[7] ^ data_gen_crc_i[12] ^ data_gen_crc_i[5] ^ data_gen_crc_i[17] ^ data_gen_crc_i[10] ^ data_gen_crc_i[18] ^ data_gen_crc_i[3] ^ data_gen_crc_i[15] ^ data_gen_crc_i[8] ^ lfsr_q[2] ^ data_gen_crc_i[4] ^ data_gen_crc_i[23] ^ data_gen_crc_i[16] ^ data_gen_crc_i[22] ^ data_gen_crc_i[1] ;
				lfsr_c[2] = data_gen_crc_i[8] ^ data_gen_crc_i[13] ^ data_gen_crc_i[6] ^ data_gen_crc_i[18] ^ data_gen_crc_i[11] ^ data_gen_crc_i[19] ^ data_gen_crc_i[4] ^ data_gen_crc_i[16] ^ data_gen_crc_i[9] ^ lfsr_q[3] ^ data_gen_crc_i[5] ^ lfsr_q[0] ^ data_gen_crc_i[17] ^ data_gen_crc_i[23] ^ data_gen_crc_i[2] ;
				lfsr_c[3] = data_gen_crc_i[11] ^ data_gen_crc_i[4] ^ data_gen_crc_i[16] ^ data_gen_crc_i[2] ^ data_gen_crc_i[22] ^ data_gen_crc_i[15] ^ data_gen_crc_i[21] ^ data_gen_crc_i[0] ^ data_gen_crc_i[19] ^ data_gen_crc_i[12] ^ data_gen_crc_i[20] ^ data_gen_crc_i[5] ^ data_gen_crc_i[10] ^ lfsr_q[4] ^ data_gen_crc_i[18] ^ lfsr_q[0] ;
				lfsr_c[4] = data_gen_crc_i[4] ^ data_gen_crc_i[9] ^ data_gen_crc_i[2] ^ data_gen_crc_i[14] ^ data_gen_crc_i[7] ^ data_gen_crc_i[15] ^ data_gen_crc_i[0] ^ data_gen_crc_i[12] ^ data_gen_crc_i[5] ^ data_gen_crc_i[23] ^ data_gen_crc_i[1] ^ data_gen_crc_i[20] ^ data_gen_crc_i[13] ^ lfsr_q[5] ^ data_gen_crc_i[19] ;
				lfsr_c[5] = data_gen_crc_i[5] ^ data_gen_crc_i[10] ^ data_gen_crc_i[3] ^ data_gen_crc_i[15] ^ data_gen_crc_i[8] ^ data_gen_crc_i[16] ^ data_gen_crc_i[1] ^ data_gen_crc_i[13] ^ data_gen_crc_i[6] ^ lfsr_q[0] ^ data_gen_crc_i[2] ^ data_gen_crc_i[21] ^ data_gen_crc_i[14] ^ data_gen_crc_i[20] ;
			end			
			default: lfsr_c = lfsr_q;
		endcase
	end
	assign lfsr_q = (enable_crc_gen_i != 0) ? 6'b010101 : 0;
	always @(posedge clk_tx or negedge reset_n_tx) begin
		if(!reset_n_tx) begin
			crc_gen_o <=0;
			crc_gen_done_o <= 0;
		end
		else begin
			if(enable_crc_gen_i != 0) begin
				crc_gen_o <= lfsr_c;
			
			end
			if(enable_crc_gen_i == 3'b101) begin
				crc_gen_done_o <= 2'b10; //Gen done enhanced
			end
			if(enable_crc_gen_i == 3'b100) begin
				crc_gen_done_o <= 2'b01; //gen done serial
			end
			if(crc_gen_done_o != 0) crc_gen_done_o <= 0; //Turn off at next posedge clk_tx
		end
	end
	
endmodule