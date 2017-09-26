module testbench;
	reg [31:0]instruction;
	wire [2:0]OUT1addr,OUT2addr,INaddr,select;
	reg clk;
	
	CU cont(instruction,OUT1addr,OUT2addr,INaddr,select,out1mux,out2mux,immediatemux,clk);
	always
		#5 clk = ~clk;
		
	initial 
		#50 $finish;
	
	initial begin
		#5 instruction = 32'b00000111_00000001_00000010_00000100; clk = 1'b1;
		$monitor("%b",clk);
		//$monitor("OUT1addr = %b \t OUT2addr = %b \t INaddr = %b select = %b\t", OUT1addr,OUT2addr,INaddr,select);
	end
endmodule


module CU(instruction,OUT1addr,OUT2addr,INaddr,select,out1mux,out2mux,immediatemux,clk);
	input [31:0]instruction;
	input clk;
	output reg [2:0]OUT1addr;
	output reg[2:0]OUT2addr;
	output reg[2:0]INaddr,temp;
	output reg[2:0]select;
	output reg out1mux;
	output reg out2mux;
	output reg immediatemux;
	reg [7:0]opcode,destination,source1,source2;
	reg [2:0]tempOut2;
	
	always @(posedge clk) begin
		opcode = instruction[31:24];
		destination = instruction[23:16];
		source2 = instruction[15:8];
		source1 = instruction[7:0];
		
		case(destination)
			8'b0000_0000 : INaddr = 3'b000;
			8'b0000_0001 : INaddr = 3'b001;
			8'b0000_0010 : INaddr = 3'b010;
			8'b0000_0011 : INaddr = 3'b011;
			8'b0000_0100 : INaddr = 3'b100;
			8'b0000_0101 : INaddr = 3'b101;
			8'b0000_0110 : INaddr = 3'b110;
			8'b0000_0111 : INaddr = 3'b111;
			default : $display("Error Destinaion\n");
		endcase
		case(source1)
			8'b0000_0000 : OUT1addr = 3'b000;
			8'b0000_0001 : OUT1addr = 3'b001;
			8'b0000_0010 : OUT1addr = 3'b010;
			8'b0000_0011 : OUT1addr = 3'b011;
			8'b0000_0100 : OUT1addr = 3'b100;
			8'b0000_0101 : OUT1addr = 3'b101;
			8'b0000_0110 : OUT1addr = 3'b110;
			8'b0000_0111 : OUT1addr = 3'b111;
			default : $display("Error Source1 \n");
		endcase
		case(source2)
			8'b0000_0000 : OUT2addr = 3'b000;
			8'b0000_0001 : OUT2addr = 3'b001;
			8'b0000_0010 : OUT2addr = 3'b010;
			8'b0000_0011 : OUT2addr = 3'b011;
			8'b0000_0100 : OUT2addr = 3'b100;
			8'b0000_0101 : OUT2addr = 3'b101;
			8'b0000_0110 : OUT2addr = 3'b110;
			8'b0000_0111 : OUT2addr = 3'b111;
			default : $display("Error Source2\n");
		endcase
		select =  opcode[2:0];
		if(opcode == 8'b0000_1000)begin		// loadi instruction
			out1mux = 1'b0;
			out2mux = 1'b0;
			immediatemux = 1'b1;
		end
		if(opcode == 8'b0000_0000)begin		// mov instruction
			out1mux = 1'b1;
			out2mux = 1'b0;
			immediatemux = 1'b0;
		end
		if(opcode == 8'b0000_0001)begin		// add or sub instruction
			out1mux = 1'b1;
			out2mux = 1'b1;
			immediatemux = 1'b0;
		end
		if(opcode == 8'b0000_0010)begin 	//and instruction
			out1mux = 1'b1;
			out2mux = 1'b1;
			immediatemux = 1'b0;
		end
		if(opcode == 8'b0000_0011)begin 	//or instruction
			out1mux = 1'b1;
			out2mux = 1'b1;
			immediatemux = 1'b0;
		end
		//use the instruction flow given in the last page. Convert them to 32bit binary.
	end
	
endmodule