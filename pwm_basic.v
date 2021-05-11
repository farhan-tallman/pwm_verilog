`timescale 1ns / 1ps

module pwm_basic(
	input wire clk,
	input wire rst_i,
	input [6:0] duty_cycle, // min 0, max 100
	output led0
	);
	
	//internal wires and regs
	reg [9:0] counter = 0;
	
	always@(posedge clk or posedge rst_i)
	begin
		if(rst_i)
			counter <= 0;
		else
			//counter <= counter + 1;
			if(counter <= 1000)
				counter <= counter +1;
			else
				counter <= 0;
	end
	
	assign led0 = (counter < (duty_cycle*10) ) ? 0 : 1;  
	
endmodule