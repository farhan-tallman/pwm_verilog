`timescale 1ns / 1ps

module count_debounce(
	input wire clk,
	input wire rst_i,
	input wire count_up_i,
	output reg [6:0] count_o
	);
	
	//internal wires and regs
	wire btn_press;
	wire btn_ready;
	
	
	//debounce the input
	debounce debounce1(
		.clk(clk),
		.rst_i(rst_i),
		.btn_i(count_up_i),
		.btn_press_o(btn_press),
		.ready_o(btn_ready)
	);
	
	always@(posedge clk or posedge rst_i)
		begin
			if(rst_i)
				count_o <= 0;
			else
				if(btn_ready && btn_press)
					begin
						if(count_o <= 90)
							count_o <= count_o + 10;
						else
							count_o <= 0;
					end
		end
		
endmodule