module sent_rx_pulse_decode (
	//clk rx and reset_n_rx
	input clk_rx,
	input reset_n_rx,

	//input from sent tx
	input sent_rx_i,
	
	//output to crc check
	output reg [29:0] data_check_crc_o,
	output reg [2:0] done_pre_data_o,
	
	//output to sent rx control
	output reg [1:0] channel_format_decode_o,
	output reg [7:0] id_decode_o,
	output reg [15:0] data_decode_o,
	output reg pause_decode_o,
	output reg config_bit_decode_o,
	output reg start_o,
	//output to store fifo
	output reg write_enable_store_o,
	output reg [11:0] data_o
	
	);
	
	localparam IDLE = 3'b000;
	localparam CALIBRATION = 3'b001;
	localparam CHECK = 3'b010;
	localparam STATUS = 3'b011;
	localparam DATA = 3'b100;
	localparam PAUSE = 3'b101;	

	reg prev_data_clk;
	reg ticks;
	reg [10:0] b;
	reg [20:0] counter2;
	reg [10:0] count;
	reg [2:0] state_rx;
	reg [10:0] count_data;
	reg [5:0] count_frame;
	reg [7:0] saved_bit3_status;
	reg [17:0] saved_bit2_status;
	reg done_decode_statuss;
	reg done_one_nibble;
	reg [3:0] count_nibbles;
	reg first_frame;
	reg [2:0] count_enable;
	reg count_store;
	reg [1:0] done_data_to_fifo;
	reg [11:0] count_frame_ticks;
	reg start_gen_ticks;
	reg check_channel_format;
	reg saved_channel_format;
	reg [1:0] done_state_data;
	reg prev_ticks;
	reg check_next_nibble;
	reg [3:0] store_nibble;
	reg pause;
	reg [3:0] data_nb;
    reg check_channel_fast;
	reg decode_config_bit;
	reg calib;

	always @(posedge clk_rx or negedge reset_n_rx) begin
		if(!reset_n_rx) begin
			prev_data_clk <= 0;
			ticks <= 0;
			b <= 0;
			counter2 <= 0;
			count <= 0;
 			state_rx <= IDLE;
			count_data <= 0;
			count_frame <= 0;
			saved_bit3_status <= 0;
			saved_bit2_status <= 0;
			done_decode_statuss <= 0;
			done_one_nibble <= 0;
			count_nibbles <= 0;
			first_frame <= 0;
			count_enable <= 0;
			done_data_to_fifo <= 0;
			count_frame_ticks <= 0;
			start_gen_ticks <= 0;
			check_channel_format <= 0;
			saved_channel_format <= 0;
			done_state_data <= 0;
			prev_ticks <= 0;
			check_next_nibble <= 0;
			store_nibble <= 0;
			pause <= 0;
    		calib <= 0;
			decode_config_bit <= 0;	
			data_check_crc_o <=0;
			done_pre_data_o <=0;
	 		channel_format_decode_o <=0;
	 		id_decode_o <=0;
	 		data_decode_o <=0;
	 		pause_decode_o <=0;
	 		config_bit_decode_o <=0;
	 		start_o <=0;
	 		write_enable_store_o <=0;
	 		data_o <= 0;
			check_channel_fast <= 0;	
			count_store <= 0;
		end
		else begin
			prev_ticks <= ticks; 
			prev_data_clk <= sent_rx_i;      

			case(state_rx)
				IDLE: begin	
					//change state
					if((sent_rx_i==0) && (prev_data_clk==1)) begin
						state_rx <= CALIBRATION;
						calib <= 1; //calibration for the first nibble
						start_o <= 1; //send announce to sent rx control
					end

					first_frame <= 0;
					count_frame <= 0;
					counter2 <= 0;
					start_gen_ticks <= 0;
					count <= 0;
					saved_bit3_status <= 0;
					saved_bit2_status <= 0;
					ticks <= 0;
					b <= 0;
				end

				CALIBRATION: begin
					count_nibbles <= 0;
					
					//frame dau tien, tinh toan lai ticks, roi tu frame sau state se la sync thong thuong
					if(calib) begin
						if((sent_rx_i==0) && (prev_data_clk==1)) begin
							state_rx <= STATUS;
							b <= (counter2-2)/56/2;	
							start_gen_ticks <= 1;
							calib <= 0;
						end
						else counter2 <= counter2 + 1;
					end else begin 
						if((sent_rx_i==0) && (prev_data_clk==1)) begin
							state_rx <= STATUS;
						end
					end
				end

				STATUS: begin
					data_check_crc_o <= 0;
					if((sent_rx_i==0) && (prev_data_clk==1)) begin
				
						if(!first_frame) begin state_rx <= CHECK; check_channel_fast <= 1; end
						else begin state_rx <= DATA; end
						if(count_frame == 7 && saved_channel_format) begin
							decode_config_bit <= 1;
						end
						data_nb <= count_data - 12;
						done_decode_statuss <= 1;
						
					end 
				end
				CHECK: begin
					if(check_channel_fast) begin 
						if( data_nb[3:2] == 2'b00 ) begin
							channel_format_decode_o <= 2'b10;
						end
					end
					first_frame <= 1;
					check_channel_format <= 1;

					if(check_next_nibble) begin
						if(count_data > 27) begin
							state_rx <= CALIBRATION;
							count_frame_ticks <= 0;
							count_data <= 0;	
							check_next_nibble <= 0;
							end
						else begin
							if ((sent_rx_i == 0) && (prev_data_clk == 1)) begin
								count_frame <= 1;
								state_rx <= DATA;
								check_next_nibble <= 0;
								count_data <= 0;
								count_nibbles <= 0;
								data_nb <= count_data -12;
								store_nibble <= count_nibbles -1;
								done_decode_statuss <= 1;
								count_data <= 0;
								count_frame_ticks <= 0;
								pause_decode_o <= pause;
	
								case(count_nibbles) 
									8: begin pause <= 1; done_state_data <= 2'b01; end
									6: begin pause <= 1; done_state_data <= 2'b10; end
									7: begin pause <= 0; done_state_data <= 2'b01; end
									4: begin pause <= 0; done_state_data <= 2'b11; end
									5: begin
										if(count_frame_ticks > 200) begin
											pause <= 1; done_state_data <= 2'b11;
										end
										else begin pause <= 0; done_state_data <= 2'b10; end 
									end
								endcase

								if(count_nibbles == 8 || count_nibbles == 6) begin 
									pause <= 1;
								end
								else if(count_nibbles == 7 || count_nibbles == 4)begin
									pause <= 0;
								end
								else if(count_nibbles == 5) begin 
									if(count_frame_ticks > 200) begin
										pause <= 1;
									end
									else pause <= 0;
								end
							end
						end
					end
					else begin
						if((ticks==1) && (prev_ticks==0)) begin
							count_frame_ticks <= count_frame_ticks + 1;
						end
						
						if ((sent_rx_i == 0) && (prev_data_clk == 1)) begin
							count_data <= 0;
							state_rx <= CHECK;
							if(count_nibbles > 7 || count_data > 56 || (count_data < 56 && count_data >27) ) begin 
									count_frame <= count_frame + 1; 
									state_rx <= CALIBRATION; 
									store_nibble <= count_nibbles - 1 ; 
									pause <= 1; 
									pause_decode_o <= 1;
									done_pre_data_o <= 3'b001;
									done_data_to_fifo <= 2'b01;
									count_frame_ticks <= 0;
									end
							else if(count_data == 56) begin check_next_nibble <= 1; count_frame_ticks <= count_frame_ticks - 56; end
							else begin data_nb <= count_data - 12; done_one_nibble <= 1; count_nibbles <= count_nibbles + 1; end
						end
					end
					if(channel_format_decode_o == 2'b10) begin
						channel_format_decode_o <= 2'b10;
						if((sent_rx_i==1) && (prev_data_clk==0) && (count_data == 5)) begin
							state_rx <= IDLE;
							case(count_nibbles)
								7: begin done_state_data <= 2'b01; data_decode_o <= 16'h001; end
								5: begin done_state_data <= 2'b10; data_decode_o <= 16'h003; end
								4: begin done_state_data <= 2'b11; data_decode_o <= 16'h002; end
							endcase
						end
						if ((sent_rx_i == 0) && (prev_data_clk == 1)) begin
							count_data <= 0;
							
							if(count_data > 27 ) begin 
									state_rx <= IDLE; 
									pause <= 1; 
									pause_decode_o <= 1;
									done_pre_data_o <= 3'b001;
									done_data_to_fifo <= 2'b01;
									count_frame_ticks <= 0;
							end
							else begin
								data_nb <= count_data - 12;
								state_rx <= CHECK;
								count_nibbles <= count_nibbles + 1;
							end
						end
					end 
				end
				DATA: begin
					
					//DECODE CHANNEL FORMAT = STATUS NIBBLE IN 2TH FRAME
					if(check_channel_format) begin
						check_channel_format <= 0;
						if(data_nb[3]) begin 
							channel_format_decode_o <= 2'b01; //enhanced
							saved_channel_format <= 1; 
						end
						else begin 
							channel_format_decode_o <= 2'b00; //serial
							saved_channel_format <= 0; end
					end
					
					//DECODE CONFIG BIT = STATUS NIBBLE IN 8TH FRAME
					if(decode_config_bit) config_bit_decode_o <= data_nb[3];
					
					if ((sent_rx_i==0) && (prev_data_clk == 1)) begin
						data_nb <= count_data - 12;
						count_data <= 0;
						done_one_nibble <= 1;

						if(count_nibbles == store_nibble) begin
							//PRE DATA FAST
							case(count_nibbles)
								6: begin done_state_data <= 2'b01; end
								4: begin done_state_data <= 2'b10; end
								3: begin done_state_data <= 2'b11; end
							endcase

						//STATE -> PAUSE OR SYNC
							if(pause) begin state_rx <= PAUSE;  end
							else begin 
								if( (!saved_channel_format && count_frame == 15) || (saved_channel_format && count_frame == 17) ) begin 
									state_rx <= IDLE; 
									saved_channel_format <= 0; 
									first_frame <= 0;
									count_frame <= 0;
									count_nibbles <= 0;
								end
								else begin
									state_rx <= CALIBRATION; 
									count_frame <= count_frame + 1; 
								end
							end
						end
						else begin
							count_nibbles <= count_nibbles + 1;
						end
					end
					else begin 
						state_rx <= DATA; 
					end 
				end

				PAUSE: begin
					if ( (sent_rx_i == 0) && (prev_data_clk == 1) ) begin
						if( (!saved_channel_format && count_frame == 15) || (saved_channel_format && count_frame == 17) ) begin 
							state_rx <= IDLE; 
							saved_channel_format <= 0; 
							first_frame <= 0;
							count_frame <= 0;
							pause <= 0;
							count_nibbles <= 0;
						end
						else begin
							state_rx <= CALIBRATION;
							count_frame <= count_frame + 1;	
						end
					end
					else state_rx <= PAUSE;
				end
			endcase
			
			case(done_data_to_fifo)
				2'b01: begin
					if(count_enable) begin
						write_enable_store_o <= 1;
						count_enable <= 0;
						if(!count_store) begin
							data_o <= data_check_crc_o[27:16]; 
							count_store <= 1; 
						end else begin 
							data_o <= data_check_crc_o[15:4]; 
							count_store <= 0; 
							done_data_to_fifo <= 0;
							done_pre_data_o <= 3'b001;
						end
						end
					else begin count_enable <= 1; end
				end

				2'b10: begin
					if(count_enable) begin
						write_enable_store_o <= 1;
						count_enable <= 0;
						data_o <= {data_check_crc_o[18:16],data_check_crc_o[14:12],data_check_crc_o[10:8],data_check_crc_o[6:4]}; 
						done_data_to_fifo <= 0;
						done_pre_data_o <= 3'b010;
					end
					else begin count_enable <= 1; end
				end

				2'b11: begin
					if(count_enable) begin
						write_enable_store_o <= 1;
						count_enable <= 0;
						data_o <= data_check_crc_o[15:4]; 
						done_data_to_fifo <= 0;
						done_pre_data_o <= 3'b011;
					end
					else begin count_enable <= 1; end
				end
			endcase

			if(start_gen_ticks) begin
				if (count == b) begin
					ticks <= ~ticks;
					count <= 0;
				end
				else count <= count + 1;
			end

			//dem suon duong tick
			if((ticks==1) && (prev_ticks==0)) begin
				count_data <= count_data + 1;
			end

			//khi ket thuc 1 state, count_data = 0
			if((sent_rx_i==0) && (prev_data_clk==1)) begin
				count_data <= 0;
			end

			//luu status
			if(done_decode_statuss) begin
				if( (count_frame >= 8 && count_frame <= 11) || (count_frame >= 13 && count_frame <= 16) ) begin saved_bit3_status <= {saved_bit3_status,data_nb[3]}; end
				saved_bit2_status <= {saved_bit2_status,data_nb[2]};
				done_decode_statuss <= 0;
				if(!saved_channel_format && count_frame == 15) begin done_pre_data_o <= 3'b100; end
				else if(saved_channel_format && count_frame == 17) begin done_pre_data_o <= 3'b101; end
			end

			//SHIFT DATA NIBBLE
			//SHIFT DATA NIBBLE			
			if(done_one_nibble) begin
				data_check_crc_o <= {data_check_crc_o,data_nb};
				done_one_nibble <= 0;
			end
			
			if(done_state_data == 2'b01 && !done_one_nibble) begin done_state_data <= 0;  done_data_to_fifo <= 2'b01;end
			else if(done_state_data == 2'b10 && !done_one_nibble) begin  done_state_data <= 0;  done_data_to_fifo <= 2'b10; end
			else if(done_state_data == 2'b11 && !done_one_nibble) begin done_state_data <= 0;  done_data_to_fifo <= 2'b11;end

			if(done_pre_data_o == 3'b100) begin
				data_check_crc_o <= saved_bit2_status[15:0];
				id_decode_o <= saved_bit2_status[15:12];
				data_decode_o <= saved_bit2_status[11:4];
			end

			if(done_pre_data_o == 3'b101) begin
				data_check_crc_o <= {saved_bit2_status[11], 1'b0, saved_bit2_status[10], config_bit_decode_o,
								saved_bit2_status[9], saved_bit3_status[7], saved_bit2_status[8], saved_bit3_status[6],
								saved_bit2_status[7], saved_bit3_status[5], saved_bit2_status[6], saved_bit3_status[4],
								saved_bit2_status[5], 1'b0, saved_bit2_status[4], saved_bit3_status[3],
								saved_bit2_status[3], saved_bit3_status[2], saved_bit2_status[2], saved_bit3_status[1],
								saved_bit2_status[1], saved_bit3_status[0], saved_bit2_status[0], 1'b0,
								saved_bit2_status[17], saved_bit2_status[16], saved_bit2_status[15], saved_bit2_status[14],
								saved_bit2_status[13], saved_bit2_status[12] };

				if(config_bit_decode_o) begin
					id_decode_o <= saved_bit3_status[7:4];
					data_decode_o <= {saved_bit3_status[3:0], saved_bit2_status[11:0]};
				end
				else begin
					id_decode_o <= saved_bit3_status;
					data_decode_o <= saved_bit2_status[11:0];
				end
			end

			//Turn off at next posedge clk_rx
			if(start_o) start_o <=0;	
			if(decode_config_bit) decode_config_bit <= 0;
			if(check_channel_fast) check_channel_fast <= 0;
			if(write_enable_store_o) write_enable_store_o <= 0;
			if(done_pre_data_o != 0) done_pre_data_o <= 3'b000;
		end
	end
endmodule