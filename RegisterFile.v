module RegisterFile;

	wire [7:0]OUT1,OUT2;
	reg [2:0] OUT1addr,OUT2addr,INaddr;
	reg RESET,clk;
	reg [7:0]IN;
	
	reg_file REGISTER(IN,OUT1,OUT2,clk,RESET,INaddr,OUT1addr,OUT2addr);
		
	always
		#5 clk = ~clk;
		
	initial
		#20 $finish;
		
	initial begin  
	clk = 1'b1;
//	 $monitor("time = %d \t clock 1= %b ",$time,clk);
	#5 OUT1addr = 3'b001; OUT2addr = 3'b000; INaddr = 3'b101; RESET = 1'b1; IN = 8'b1111_1111;  
	 $monitor("Out 1 = %b Out 2 = %b OUT1addr = %b OUT2addr = %b IN = %b clock = %b \n",OUT1, OUT2, OUT1addr,OUT2addr,IN,clk);
	
	OUT1addr = 3'b001; OUT2addr = 3'b000; INaddr = 3'b101; RESET = 1'b1; IN = 8'b1011_0111; 
	#10 $monitor("Out 1 = %b Out 2 = %b OUT1addr = %b OUT2addr = %b IN = %b clock = %b \n",OUT1, OUT2, OUT1addr,OUT2addr,IN,clk);
		
	OUT1addr = 3'b001; OUT2addr = 3'b000; INaddr = 3'b101; RESET = 1'b1; IN = 8'b0000_0111; 
	#15 $monitor("Out 1 = %b Out 2 = %b OUT1addr = %b OUT2addr = %b IN = %b clock = %b \n",OUT1, OUT2, OUT1addr,OUT2addr,IN,clk);
		
	OUT1addr = 3'b001; OUT2addr = 3'b000; INaddr = 3'b001; RESET = 1'b1; IN = 8'b1001_0101;  
	#20	$monitor("Out 1 = %b Out 2 = %b OUT1addr = %b OUT2addr = %b IN = %b clock = %b \n",OUT1, OUT2, OUT1addr,OUT2addr,IN,clk);
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
	// stores value to the registers 
	initial begin
		registers[3'b000] = 8'b0000_0000;
		registers[3'b001] = 8'b0000_0001;
		registers[3'b010] = 8'b0000_0010;
		registers[3'b011] = 8'b0000_0011;
		registers[3'b100] = 8'b0000_0100;
		registers[3'b101] = 8'b0000_0101;
		registers[3'b110] = 8'b0000_0110;
		registers[3'b111] = 8'b0000_0111;
	end 
	
	always @(negedge clk)begin
		registers[INaddr] = IN; 	// in negetive edges value in IN register stores registerFile at the location specify by the INaddr
	//	temp = registers[INaddr];	
		$display("negetive edge");
		$display("Value of INaddr : %b ", registers[INaddr]);
	end
	
	always @(posedge clk)begin
		temp = registers[OUT1addr];
		temp1 = registers[OUT2addr]; 
		$display("positive edge");
		$display("Value of INaddr : %b ", registers[INaddr]);
	end

	assign OUT1 = temp;
	assign OUT2 = temp1;

endmodule 