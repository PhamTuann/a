module sent_tx_gen_ticks(
	input clk_tx,
	input reset_n_tx,
	output reg ticks_o,
	input [7:0] divide_i
	);

	reg [15:0] counter;

	always @(posedge clk_tx or negedge reset_n_tx) begin
		if(!reset_n_tx) begin
			ticks_o <= 0;
			counter <= 0;
		end
		else begin
			if (counter == (divide_i/2) - 1) begin //gen ticks
				ticks_o <= ~ticks_o;
				counter <= 0;
			end
			else counter <= counter + 1;
		end
	end
endmodule
