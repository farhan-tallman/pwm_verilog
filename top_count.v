`timescale 1ns / 1ps

module top_count(
	input wire clk,
	input wire rst_i,
	input btn_up_i,
	output [6:0] ssd_o,
	output sel_o,
	output wire led0
	);
	
	// Local wires and regs
	wire [6:0] num_display;
	
	
	
	//ssd instantiation
	ssd ssd1(
		.clk(clk),
		.rst_i(rst_i),
		.num_i(num_display),
		.a2g_o(ssd_o),
		.sel_o(sel_o)
	);
	
	//counter instantiation
	count_debounce count_debounce1(
		.clk(clk),
		.rst_i(rst_i),
		.count_up_i(btn_up_i),
		.count_o(num_display)
		
	);
	
	//pwm basic instantiation
	pwm_basic pwm_basic1(
		.clk(clk),
		.rst_i(rst_i),
		.duty_cycle(num_display),
		.led0(led0)
	);

	
endmodule