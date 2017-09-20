module RegisterFile;

	wire [7:0]OUT1,OUT2;
	reg [2:0] OUT1addr,OUT2addr,INaddr;
	reg RESET,clk;
	reg [7:0]IN;
	
	reg_file REGISTER(IN,OUT1,OUT2,clk,RESET,INaddr,OUT1addr,OUT2addr);
	
	always
		#5 clk = ~clk;
		
	initial
		#100 $finish;
		
	initial begin
	
	// test the clear input
	#5 OUT1addr = 3'b010; OUT2addr = 3'b011; INaddr = 3'b101; RESET = 1'b1; clk = 1'b1; IN = 8'b1001_0111 ; 
	#5	$display("Out 1 = %b Out 2 = %b OUT1addr = %b OUT2addr = %b ",OUT1, OUT2, OUT1addr,OUT2addr);
	
	#5 OUT1addr = 3'b111; OUT2addr = 3'b000; INaddr = 3'b101; RESET = 1'b1; clk = 1'b1; IN = 8'b1001_0111 ; 
	#5	$display("Out 1 = %b Out 2 = %b OUT1addr = %b OUT2addr = %b ",OUT1, OUT2, OUT1addr,OUT2addr);
	end 

endmodule


module reg_file(IN,OUT1,OUT2,clk,RESET,INaddr,OUT1addr,OUT2addr);

	input [7:0]IN;
	input clk;
	input [2:0]INaddr,OUT1addr,OUT2addr;
	input RESET;
	
	output [7:0]OUT1,OUT2;
	reg [7:0]temp;
	
	reg [7:0]registers[7:0]; 
	
	always @(negedge clk)begin
		registers[0] = 8'b1000_1000;
		temp = registers[0];
		registers[3'b001] = 8'b1000_1000;
	
	end

	assign OUT1 = temp;

endmodule 