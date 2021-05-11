`timescale 1ns / 1ps

module debounce(
	input wire clk,
	input wire rst_i,
	input wire btn_i,
	output reg btn_press_o,
	output reg ready_o
	);
	
	parameter IDLE = 3'd0;
	parameter START = 3'd1;
	parameter WAIT = 3'd2;
	parameter CONFIRM = 3'd3;
	parameter WAIT_RELEASE = 3'd4;
	parameter WAIT_SOME_MORE = 3'd5;
	parameter ALMOST_READY = 3'd6;
	parameter READY = 3'd7;
	
	//internal wires and nets
	reg [2:0] current_state = IDLE;
	reg [2:0] next_state;
	reg start_count;
	wire done_count;
	reg btn_press_w;
	reg ready_w;
	
	// Mocule that counts 20ms delay
	delay_counter delay_counter1(
		.clk(clk),
		.rst_i(rst_i),
		.start_i(start_count),
		.done_o(done_count)
		);
	
	always@*
	begin
		case(current_state)
			IDLE: //0
				begin
					btn_press_w = 0;
					ready_w = 0;
					start_count = 0;
					if(btn_i)
						next_state = START;
					else
						next_state = IDLE;
				end
			START: //1
				begin
					btn_press_w = 0;
					ready_w = 0;
					if(btn_i)
						begin
							start_count = 1;
							next_state = WAIT;
						end
					else
						begin
							start_count = 0;
							next_state = IDLE;
						end
				end
			WAIT: //2
				begin
					btn_press_w = 0;
					ready_w = 0;
					start_count = 0;
					if(btn_i)
						begin		
							if(done_count)
								next_state = CONFIRM;
							else
								next_state = WAIT;
						end
					else
						next_state = IDLE;
				end
			CONFIRM: //3
				begin
					ready_w = 0;
					btn_press_w = 0;
					start_count = 0;
					if(btn_i)
						next_state = WAIT_RELEASE;
					else
						next_state = IDLE;
				end
			WAIT_RELEASE: //4
				begin // wait for button release
					ready_w = 0;
					btn_press_w = 0;
					start_count = 0;
					if(btn_i)
						next_state = WAIT_RELEASE;
					else
						next_state = READY;
				end
			WAIT_SOME_MORE: //5
				begin
					ready_w = 0;
					btn_press_w = 0;
					start_count = 1; // start 20ms counter again
				end
			ALMOST_READY:
				begin
					ready_w = 0;
					btn_press_w = 0;
					start_count = 0;
					if(done_count)
						next_state = READY;
					else
						next_state = ALMOST_READY;
				
				end
				
			READY: //7
				begin // set output for 1 clk
					ready_w = 1;
					btn_press_w = 1;
					start_count = 0;
					next_state = IDLE;
				end
			
		default:
			begin
				btn_press_w = 0;
				ready_w = 0;
				start_count = 0;
				next_state = IDLE;
			end
		endcase
	end// always@*
	
	
	always@(posedge clk or posedge rst_i)
	begin
		if(rst_i)
			current_state <= IDLE;
		else
			begin
				btn_press_o <= btn_press_w;
				ready_o <= ready_w;
				current_state <= next_state;
			end
	end
	
	
endmodule