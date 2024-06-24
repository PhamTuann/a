module apb_rx 
	#(parameter ADDRESSWIDTH= 5,
	parameter DATAWIDTH= 16)

	(
	input PCLK_rx,
	input PRESETn_rx,
	input [ADDRESSWIDTH-1:0]PADDR_rx_i,
	input PWRITE_rx_i,
	input PSELx_rx_i,
	input PENABLE_rx_i,
	output reg [DATAWIDTH-1:0] PRDATA_rx_o,
	output PREADY_rx_o,

	input [15:0] reg_receive_rx,		//READ ONLY
	input [15:0] reg_id_rx,			//READ ONLY
	input [15:0] reg_data_field_rx,		//READ ONLY
	input [15:0] reg_command_rx,		//READ ONLY	
	input [15:0] reg_status_rx,		//READ ONLY
	output reg read_enable_rx
	
	);
	assign PREADY_rx_o = 1;

	always @(posedge PCLK_rx or negedge PRESETn_rx) begin
 		if(!PRESETn_rx) begin
			PRDATA_rx_o <= 0;
			read_enable_rx <= 0;
		end
		else begin
			if(!PWRITE_rx_i & PSELx_rx_i) begin
				case (PADDR_rx_i)
					0: begin
						if(!reg_status_rx[7]) begin	
							PRDATA_rx_o <= reg_receive_rx;
							read_enable_rx <= 1;
						end
					end
					4: PRDATA_rx_o <= reg_id_rx;
					8: PRDATA_rx_o <= reg_data_field_rx;
					12: PRDATA_rx_o <= reg_status_rx;
					16: PRDATA_rx_o <= reg_command_rx;
					//default: PRDATA_rx_o <= 0;
				endcase
			end

			if (read_enable_rx) read_enable_rx <= 0;
	
		end
	end
endmodule
