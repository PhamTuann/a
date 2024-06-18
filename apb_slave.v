module apb_tx
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
	output reg [DATAWIDTH-1:0] PRDATA_tx_o,
	output PREADY_tx_o,

	//REGISTER
	output reg [7:0] prescale_tx,
	output reg [7:0] reg_command_tx,		//RW
	output reg [11:0] reg_transmit_tx,	//RW
	output reg [7:0] reg_id_tx,		//RW
	output reg [15:0] reg_data_field_tx,		//RW
 	input [7:0] reg_status_tx,
	//output control fifo tx
	output reg write_enable_tx
	
	);
	assign PREADY_tx_o = 1;
	always @(posedge PCLK_tx or negedge PRESETn_tx) begin
 		if(!PRESETn_tx) begin
			PRDATA_tx_o <= 0;
			reg_command_tx <= 0;
			reg_transmit_tx <= 0; 
			reg_id_tx <= 0;
			reg_data_field_tx <= 0;
			write_enable_tx <= 0;
			prescale_tx <= 8'b00000000;
		end
		else begin
			if (PENABLE_tx_i & PWRITE_tx_i & PSELx_tx_i) begin
				case (PADDR_tx_i)
					0: prescale_tx <= PWDATA_tx_i[7:0];
					1: reg_command_tx <= PWDATA_tx_i[7:0];
					2: begin
						if(!reg_status_tx[7]) begin	
							reg_transmit_tx <= PWDATA_tx_i[11:0];
								write_enable_tx <= 1;
						end
		
					end
					3: reg_id_tx <= PWDATA_tx_i[7:0];
					4: reg_data_field_tx <= PWDATA_tx_i[15:0];
					//default: reg_transmit_tx <= PWDATA_tx_i[11:0];
				endcase
			end
			if(write_enable_tx) write_enable_tx <= 0;
			if(PENABLE_tx_i & !PWRITE_tx_i & PSELx_tx_i) begin
				case (PADDR_tx_i)
					0: PRDATA_tx_o <= prescale_tx;
					1: PRDATA_tx_o <= reg_command_tx;
					2: PRDATA_tx_o <= reg_transmit_tx;
					3: PRDATA_tx_o <= reg_id_tx;
					4: PRDATA_tx_o <= reg_data_field_tx;
					5: PRDATA_tx_o <= reg_status_tx;
					default: PRDATA_tx_o <= 0;
				endcase
			end
		end
	end
endmodule


// module apb_tx
// 	#(parameter ADDRESSWIDTH= 3,
// 	parameter DATAWIDTH= 16)

// 	(
// 	input PCLK_tx,
// 	input PRESETn_tx,
// 	input [ADDRESSWIDTH-1:0]PADDR_tx_i,
// 	input [DATAWIDTH-1:0] PWDATA_tx_i,
// 	input PWRITE_tx_i,
// 	input PSELx_tx_i,
// 	input PENABLE_tx_i,
// 	output reg [DATAWIDTH-1:0] PRDATA_tx_o,
// 	output PREADY_tx_o,

// 	//REGISTER
// 	output reg [7:0] prescale_tx,
// 	output reg [7:0] reg_command_tx,		//RW
// 	output reg [11:0] reg_transmit_tx,	//RW
// 	output reg [7:0] reg_id_tx,		//RW
// 	output reg [15:0] reg_data_field_tx,		//RW
//  	input [7:0] reg_status_tx,
// 	//output control fifo tx
// 	output reg write_enable_tx
	
// 	);
// 	assign PREADY_tx_o = 1;
// 	always @(posedge PCLK_tx or negedge PRESETn_tx) begin
//  		if(!PRESETn_tx) begin
// 			PRDATA_tx_o <= 0;
// 			reg_command_tx <= 0;
// 			reg_transmit_tx <= 0; 
// 			reg_id_tx <= 0;
// 			reg_data_field_tx <= 0;
// 			write_enable_tx <= 0;
// 			prescale_tx <= 8'b00000000;
// 		end
// 		else begin
// 			if (PENABLE_tx_i & PWRITE_tx_i & PSELx_tx_i) begin
// 				if (PADDR_tx_i == 0) begin
// 					prescale_tx <= PWDATA_tx_i[7:0];
// 				end
// 				else if (PADDR_tx_i == 1) begin
// 					reg_command_tx <= PWDATA_tx_i[7:0];
// 				end
// 				else if (PADDR_tx_i == 1) begin
// 					reg_command_tx <= PWDATA_tx_i[7:0];
// 				end
// 				else if (PADDR_tx_i == 2) begin
// 					reg_command_tx <= PWDATA_tx_i[7:0];
// 				end
// 				else if (PADDR_tx_i == 3) begin
// 					reg_command_tx <= PWDATA_tx_i[7:0];
// 				end
// 				else if (PADDR_tx_i == 4) begin
// 					reg_command_tx <= PWDATA_tx_i[7:0];
// 				end

// 				case (PADDR_tx_i)
// 					0: prescale_tx <= PWDATA_tx_i[7:0];
// 					1: reg_command_tx <= PWDATA_tx_i[7:0];
// 					2: begin
// 						if(!reg_status_tx[7]) begin	
// 							reg_transmit_tx <= PWDATA_tx_i[11:0];
// 							write_enable_tx <= PENABLE_tx_i;
// 						end
						
// 					end
// 					3: reg_id_tx <= PWDATA_tx_i[7:0];
// 					4: reg_data_field_tx <= PWDATA_tx_i[15:0];
// 					//default: reg_transmit_tx <= PWDATA_tx_i[11:0];
// 				endcase
// 			end
			
// 			if(PENABLE_tx_i & !PWRITE_tx_i & PSELx_tx_i) begin
// 				case (PADDR_tx_i)
// 					0: PRDATA_tx_o <= prescale_tx;
// 					1: PRDATA_tx_o <= reg_command_tx;
// 					2: PRDATA_tx_o <= reg_transmit_tx;
// 					3: PRDATA_tx_o <= reg_id_tx;
// 					4: PRDATA_tx_o <= reg_data_field_tx;
// 					5: PRDATA_tx_o <= reg_status_tx;
// 					default: PRDATA_tx_o <= 0;
// 				endcase
// 			end
// 		end
// 	end
// endmodule