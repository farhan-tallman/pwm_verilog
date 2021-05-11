`timescale 1ns / 1ps

module delay_counter(
	input clk,
	input rst_i,
	input start_i,
	output reg done_o
	);
	//state values
	parameter IDLE      = 3'd0;
    parameter COUNT_DOWN  = 3'd1;
    parameter WAIT      = 3'd2;
    parameter READY     = 3'd3;
	
	parameter COUNTER_VALUE = 20000;
	
	// internal variables
	reg [14:0] r_counter;
	reg [14:0] w_counter;
	
	reg [2:0] current_state;
	reg [2:0] next_state;
	reg en_flag;
	reg count_done_flag;
	
	always@(posedge clk or posedge rst_i)
	begin
		if(rst_i)
			begin
				current_state <= IDLE;
			end
		else
			begin
				current_state <= next_state;
				r_counter <= w_counter;
			end
	end
	
	always@*
	begin
		case(current_state)
			IDLE:
				begin
					done_o = 0;
					w_counter = COUNTER_VALUE;
					if(start_i)
						next_state = COUNT_DOWN;
					else
						next_state = IDLE;
				end
			COUNT_DOWN:
				begin
					w_counter = r_counter -1;
					done_o = 0;
					if(r_counter == 0)
						next_state = READY;
					else
						next_state = COUNT_DOWN;
				end
			READY:
				begin
					w_counter = COUNTER_VALUE;
					done_o = 1;
					next_state = IDLE;
				end
			default:
				begin
					w_counter = COUNTER_VALUE;
					done_o = 0;
					next_state = IDLE;
				end
		endcase
	
	end
	

endmodule