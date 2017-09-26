
module testbench;
	// +++++++++++++++++++ CONTROLLER Test ++++++++++++++++++++++++++++
	reg [31:0]instruction;
	wire [2:0]OUT1addr,OUT2addr,INaddr,select;
	wire out1mux,out2mux,immediatemux;
	reg clk;
	
	CU cont(instruction,OUT1addr,OUT2addr,INaddr,select,out1mux,out2mux,immediatemux,clk);

	//++++++++++++++++++++++++ REGISTER FILE test +++++++++++++++++++++++++++++	
	wire [7:0]OUT1,OUT2;
	reg [2:0] OUT1addrREG,OUT2addrREG,INaddrREG;
	reg RESET;
	reg [7:0]IN;
	
	reg_file REGISTER(IN,OUT1,OUT2,clk,RESET,INaddrREG,OUT1addrREG,OUT2addrREG);
	
	//+++++++++++++++++++++++++++++++++ MUX test +++++++++++++++++++++++++++++++++++++++++++++++++++++++
	wire [7:0]OUTMux,OUT2Mux;
	reg [7:0]InMux_1,InMux_2,In2Mux_1,In2Mux_2;
	reg muxselect,mux2select;
	
	MUX mux1(InMux_1, InMux_2, muxselect, OUTMux);
	MUX mux2(In2Mux_1, In2Mux_2, mux2select, OUT2Mux);
	
	//++++++++++++++++++++++++++++++++++ 2s COMPLIMENT test +++++++++++++++++++++++++++++++++
	wire  [7:0]OUTData_compliment, OUTData_2compliment;
	reg [7:0]InData_compliment,InData_2compliment;
	
	Compliment2 complimentBox1(InData_compliment, OUTData_compliment);
	Compliment2 complimentBox2(InData_2compliment, OUTData_2compliment);
	//===============================================================================================================================
	initial begin
		#5 assign INaddrREG = INaddr; assign OUT1addrREG = OUT1addr; assign OUT2addrREG = OUT2addr; IN = 8'b1111_1111; 
		 assign InMux_1 = OUT1; assign InData_compliment = OUT1; assign InMux_2 = OUTData_compliment; assign muxselect = out1mux;
		 assign In2Mux_1 = OUT2; assign InData_2compliment =OUT2; assign In2Mux_2 = OUTData_2compliment; assign mux2select = out2mux; 
	end
	
	always
		#5 clk = ~clk;
		
	initial 
		#25 $finish;
	
	initial begin
		#5 instruction = 32'b00000000_00000001_00000010_00000100; clk = 1'b1;
		$monitor("OUT1addr = %b \n OUT2addr = %b \n INaddr = %b select = %b\n INaddrREG = %b\n OUT2 = %b\n OUT2MUX = %b \n", OUT1addr,OUT2addr,INaddr,select,IN,OUT2,OUT2Mux);
		//$monitor("\nInData_compliment %b\n",InMux_1);
	end
endmodule

//=================================================== Controller =====================================================

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
		// controlling mux
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

//======================================= REGISTER FILE =====================================================

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
	//	$monitor("Value of INaddr : %b ", INaddr);
	end 
	
	always @(negedge clk)begin
		registers[INaddr] = IN; 	// in negetive edges value in IN register stores registerFile at the location specify by the INaddr
	//	temp = registers[INaddr];	
	//	$display("negetive edge");
	//	$display("Value of INaddr : %b ", registers[INaddr]);
	//$monitor("Value of INaddr : %b ", INaddr);
	end
	
	always @(posedge clk)begin
		temp = registers[OUT1addr];
		temp1 = registers[OUT2addr]; 
	//	$display("positive edge");
	//	$display("Value of INaddr : %b ", registers[INaddr]);
	//$monitor("Value of INaddr : %b ", OUT1addr);
	end

	assign OUT1 = temp;
	assign OUT2 = temp1;

endmodule 

//=============================================== MUX ===================================================================================
module MUX(InMux_1, InMux_2, muxselect, OUTMux);
	
	input [7:0]InMux_1;		
	input [7:0]InMux_2;	
	input muxselect;
	output [7:0]OUTMux;
	reg [7:0]temp;
	
	initial@(temp,InMux_1,InMux_2) begin
	
		if(muxselect == 1'b1)begin
			temp = InMux_1;
		end
		if(muxselect == 1'b0)begin
			temp = InMux_2;
		end
		
	end
	assign OUTMux = temp;
	
endmodule

//============================================= Compliment 2s ===========================================================================

module Compliment2(InData_compliment, OUTData_compliment);
	
	input [7:0]InData_compliment;		
	output [7:0]OUTData_compliment;
	reg [7:0]temp;
	
	initial@(temp,InData_compliment) begin
			temp = ~InData_compliment + 1'b1;		
	end
	assign  OUTData_compliment = temp;
	
endmodule
//================================================================ ALU ==================================================================

module ALU(result, overflow, x, y, carry_in, opcode);

	output [7:0]result;
	output reg overflow;
	
	input [7:0]x,y;
	input carry_in;		// Carry
	input [0:2]opcode;
	
	reg [7:0]temp;
	reg carry_out;
	
	always@(x,y,temp)
	begin
		if(opcode == 3'b010)begin		// AND operation
			temp = x & y;
			carry_out = 1'b0;
		end
		
		if(opcode == 3'b011)begin		// OR operation
			temp = x | y;
			carry_out = 1'b0;
		end
		
		if(opcode == 3'b001 && carry_in == 1'b1)begin  // ADD operation with carry 
			{carry_out,temp} = x + y + 1'b1;
			overflow = carry_out;
			
		end
		else if(opcode == 3'b001 && carry_in == 1'b0)begin		//  Add operation without carry 
			{carry_out,temp} = x + y + 1'b0;
			overflow = carry_out;
		end 
		if (opcode == 3'b100)begin		// Substractor 
			{carry_out,temp} = ~x + 1'b1 + y;		
			overflow = carry_out;	
		end
		if (opcode == 3'b000)begin		// mov and ldr opreations
			temp = y;
		end 
	end		
		assign result = temp;
	
	
endmodule