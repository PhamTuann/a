`timescale 1ns/1ns
module test_top;

	localparam ADDRESSWIDTH= 3;
	localparam DATAWIDTH= 16;
	
	reg PCLK_tx;
	reg PRESETn_tx;
	reg [ADDRESSWIDTH-1:0]PADDR_tx_i;
	reg [DATAWIDTH-1:0] PWDATA_tx_i;
	reg PWRITE_tx_i;
	reg PSELx_tx_i;
	reg PENABLE_tx_i;
	wire [DATAWIDTH-1:0] PRDATA_tx_o;
	wire PREADY_tx_o;

	reg PCLK_rx;
	reg PRESETn_rx;
	reg [ADDRESSWIDTH-1:0]PADDR_rx_i;
	reg [DATAWIDTH-1:0] PWDATA_rx_i;
	reg PWRITE_rx_i;
	reg PSELx_rx_i;
	reg PENABLE_rx_i;
	wire [DATAWIDTH-1:0] PRDATA_rx_o;
	wire PREADY_rx_o;
		
	reg clk_tx;
	reg clk_rx;

	top dut(
		.PCLK_tx(PCLK_tx),
		.PRESETn_tx(PRESETn_tx),
		.PADDR_tx_i(PADDR_tx_i),
		.PWDATA_tx_i(PWDATA_tx_i),
		.PWRITE_tx_i(PWRITE_tx_i),
		.PSELx_tx_i(PSELx_tx_i),
		.PENABLE_tx_i(PENABLE_tx_i),
		.PRDATA_tx_o(PRDATA_tx_o),
		.PREADY_tx_o(PREADY_tx_o),
		
		.PCLK_rx(PCLK_rx),
		.PRESETn_rx(PRESETn_rx),
		.PADDR_rx_i(PADDR_rx_i),
		.PWRITE_rx_i(PWRITE_rx_i),
		.PSELx_rx_i(PSELx_rx_i),
		.PENABLE_rx_i(PENABLE_rx_i),
		.PRDATA_rx_o(PRDATA_rx_o),
		.PREADY_rx_o(PREADY_rx_o),
	
		.clk_tx(clk_tx),
		.clk_rx(clk_rx)
	);


	initial begin
		PCLK_tx = 0;
		forever begin
			PCLK_tx = #10 ~PCLK_tx;
		end			
	end
	initial begin
		PCLK_rx = 0;
		forever begin
			PCLK_rx = #10 ~PCLK_rx;
		end
	end
	initial begin
		clk_tx = 0;
		forever begin
			clk_tx = #60 ~clk_tx;
		end		
	end
	initial begin
		clk_rx = 0;
		forever begin
			clk_rx = #30 ~clk_rx;
		end		
	end
	initial begin
		PRESETn_tx = 0;
		PADDR_tx_i = 0;
		PWDATA_tx_i = 0;
		PWRITE_tx_i = 0;
		PSELx_tx_i = 0;
		PENABLE_tx_i = 0;
		PRESETn_rx = 0;
		PADDR_rx_i = 0;
		PWDATA_rx_i = 0;
		PWRITE_rx_i = 0;
		PSELx_rx_i = 0;
		PENABLE_rx_i = 0;
		@(posedge PCLK_tx) 
       		PRESETn_tx = 1;
		PRESETn_rx = 1;

		//
		repeat(5) @(posedge PCLK_tx);
		PADDR_tx_i = 0;
		PWDATA_tx_i = 8'h60;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;	
		//transmit data 1
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h001;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;	
		//transmit data 1
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h002;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;	
		//transmit data 1
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h003;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;	
		//transmit data 1
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h004;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;	

		//transmit data 1
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h005;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;	
		//transmit data 1
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h006;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;	
		//transmit data 1
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h007;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;	

		//transmit data 1
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h008;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;	
		//transmit data 2 
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h009;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 3
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h00a;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 4
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h00b;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 5
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h00c;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 6
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h00d;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 7
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h00e;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h00f;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h010;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h011;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;

		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h012;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h013;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h014;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h015;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h016;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0; 
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h017;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h018;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h019;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h01a;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h01b;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h01c;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h01d;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h01e;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h01f;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h020;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h021;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h022;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h023;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h024;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h025;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h026;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h027;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h028;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h029;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h02a;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 2;
		PWDATA_tx_i = 12'h02a;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 3;
		PWDATA_tx_i = 8'h08;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		@(posedge PCLK_tx)
		PADDR_tx_i = 4;
		PWDATA_tx_i = 16'h0001;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		repeat(10) @(posedge PCLK_tx);
		PADDR_tx_i = 1;
		PWDATA_tx_i = 8'b01011000;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 0;
		PSELx_tx_i = 0;
		//transmit data 8
		repeat(20) @(posedge PCLK_tx)
		PADDR_rx_i = 1;
		PWDATA_tx_i = 8'b01010000;
		PWRITE_tx_i = 1; 
		PSELx_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i = 1;
		@(posedge PCLK_tx)
		PENABLE_tx_i= 0;
		PSELx_tx_i = 0;
		
		#50000000;
		$finish;
		
		
		
		
	end   
endmodule
