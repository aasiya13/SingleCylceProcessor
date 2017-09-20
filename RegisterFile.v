module RegisterFile;

	wire [7:0]OUT1,OUT2;
	reg [2:0] OUT1addr,OUT2addr,INaddr;
	reg RESET,clk;
	reg [7:0]IN;
	
	reg_file REGISTER(IN,OUT1,OUT2,clk,RESET,INaddr,OUT1addr,OUT2addr);
		
	//always
		//#5 clk = ~clk;
		
	//initial
		//#200 $finish;
		
	initial begin  
	OUT1addr = 3'b001; OUT2addr = 3'b000; INaddr = 3'b101; RESET = 1'b1; IN = 8'b1111_1111; clk = 1'b1; 
	#5 $display("Out 1 = %b Out 2 = %b OUT1addr = %b OUT2addr = %b IN = %b clock = %b \n",OUT1, OUT2, OUT1addr,OUT2addr,IN,clk);
	
	OUT1addr = 3'b001; OUT2addr = 3'b000; INaddr = 3'b101; RESET = 1'b1; IN = 8'b1111_0111; clk = 1'b0; 
	#10 $display("Out 1 = %b Out 2 = %b OUT1addr = %b OUT2addr = %b IN = %b clock = %b \n",OUT1, OUT2, OUT1addr,OUT2addr,IN,clk);
		
	OUT1addr = 3'b001; OUT2addr = 3'b000; INaddr = 3'b101; RESET = 1'b1; IN = 8'b0000_0111; clk = 1'b1;
	#15 $display("Out 1 = %b Out 2 = %b OUT1addr = %b OUT2addr = %b IN = %b clock = %b \n",OUT1, OUT2, OUT1addr,OUT2addr,IN,clk);
		
	OUT1addr = 3'b001; OUT2addr = 3'b000; INaddr = 3'b001; RESET = 1'b1; IN = 8'b1001_0101; clk = 1'b0 ; 
	#20	$display("Out 1 = %b Out 2 = %b OUT1addr = %b OUT2addr = %b IN = %b clock = %b \n",OUT1, OUT2, OUT1addr,OUT2addr,IN,clk);
	end

endmodule


module reg_file(IN,OUT1,OUT2,clk,RESET,INaddr,OUT1addr,OUT2addr);

	input [7:0]IN;
	input clk;
	input [2:0]INaddr,OUT1addr,OUT2addr;
	input RESET;
	
	output [7:0]OUT1,OUT2;
	reg [7:0]temp,temp1;
	
	reg [7:0]registers[7:0]; 
	
	always @(negedge clk)begin
		registers[INaddr] = IN; 	// in negetive edges value in IN register stores registerFile at the location specify by the INaddr
	//	temp = registers[INaddr];	
		$display("negetive edge");
		$display("Value of INaddr : %b ", registers[INaddr]);
	end
	
	always @(posedge clk)begin
		registers[OUT2addr] = 8'b1000_1000; // store value at the location OUT2addr
		temp = registers[OUT2addr];
		registers[OUT1addr] = 8'b1111_1000; // store value at the location OUT1addr
		temp1 = registers[OUT1addr]; 
		$display("positive edge");
		$display("Value of INaddr : %b ", registers[INaddr]);
	end

	assign OUT1 = temp;
	assign OUT2 = temp1;

endmodule 