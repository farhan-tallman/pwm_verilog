`timescale 1ns / 1ps

module ssd(
    input clk,
	input rst_i,
	input [6:0] num_i,	// the 7 bit number to be displayed
    output reg [6:0] a2g_o,	// the output controlling each segment of ssd
    output reg sel_o	// to select between the 2 SSDs
    );
	
	 //State variables
    parameter IDLE      = 3'b000;
    parameter INITIATE  = 3'b001;
    parameter WAIT      = 3'b010;
    parameter READY     = 3'b011;
    parameter DONE      = 3'b100;
	
	
	//internal variables
	wire [15:0] bcd; // to store the conveted bcd value of input
	reg [2:0] i; // loop variable
	reg [14:0] counter_ssd;
	reg [3:0] current_digit;
	reg en;
	reg en_reg;
	wire rdy;
	reg [2:0] current_state = 0;
	reg [2:0] next_state;
	reg [15:0] bcd_reg;
	
	// instantiation binary to bcd converter module
	bcdConvert bcdConvert1(
		.clk(clk),
		.en(en_reg),
		.bin_d_in({0,num_i}),
		.bcd_d_out(bcd),
		.rdy(rdy)
	);
	
	always@(posedge clk or posedge rst_i)
	begin
		if(rst_i)
			begin
				current_state <= IDLE;
				en_reg <= 0;
			end
		else
			begin
				current_state <= next_state;
				en_reg <= en;
				if(rdy)
					bcd_reg <= bcd;
			end
	end
	
	always@*
	begin
		case(current_state)
			IDLE:
				begin
					en = 1;
					next_state = WAIT;
				end
			WAIT:
				begin
					en = 0;
					if(rdy)
						next_state = READY;
					else
						next_state = WAIT;
				end
			READY:
				begin
					en = 0;
					next_state = IDLE;
				end
			default:
				begin
					en = 0;
					next_state = IDLE;
				end
				
		endcase
	end
	
	
	always@*
		begin
				
			// need to run for each of the segments for 20ms
			if (sel_o)
				current_digit = bcd_reg[3:0];
			else
				current_digit = bcd_reg[7:4];
				
				case(current_digit)
					0: a2g_o = 7'b1111110;
					1: a2g_o = 7'b0000110;
					2: a2g_o = 7'b1101101;
					3: a2g_o = 7'b1001111;
					4: a2g_o = 7'b0010111;
					5: a2g_o = 7'b1011011;
					6: a2g_o = 7'b1111011;
					7: a2g_o = 7'b0001110;
					8: a2g_o = 7'b1111111;
					9: a2g_o = 7'b1011111;
					default: 
						a2g_o = 7'b1111110;
				endcase
			//end //for loop
		end
	// Timer for SSDs
	always@(posedge clk or posedge rst_i)
	begin
		if(rst_i)
			begin
				counter_ssd <= 20000; // for 20ms
				sel_o <= 1'b0;
			end
		else
			begin
				counter_ssd <= counter_ssd -1;
				if(counter_ssd == 0)
					begin
						counter_ssd <= 20000;
						sel_o <= ~sel_o;
					end
			end
	end
	
	
endmodule
