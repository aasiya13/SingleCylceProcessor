module stimulus;
	
	reg [7:0]xIn,yIn;
	reg carry_in;
	reg [0:2]opcode;
	
	wire [7:0]result;
	wire carry_out1,overflow;
	
	ALU aluOperation(result,overflow,xIn,yIn, carry_in,opcode);
	
	initial 
		begin
		
		// To check overflow and add operation with carry in
		xIn = 8'b1010_0010; yIn = 8'b1000_0000; carry_in = 1'b1; opcode = 3'b001;
		#5  $display("\n ADD Operation With carry");
		#5	$display("Input1 = %b Input2 = %b Output = %b Overflow = %b ",xIn,yIn,result,overflow);
		
		// ADD operation no overflow without carry
		xIn = 8'b0010_0010; yIn = 8'b0100_0000; carry_in = 1'b0; opcode = 3'b001;
		#10  $display("\n ADD Operation without carry");
		#10	$display("Input1 = %b Input2 = %b Output = %b Overflow = %b ",xIn,yIn,result,overflow);
		
		// AND Operation with 
		xIn = 8'b0010_0010; yIn = 8'b1110_0010; carry_in = 1'b0; opcode = 3'b010;
		#15  $display("\n AND Operation");
		#15	$display("Input1 = %b Input2 = %b Output = %b Overflow = %b ",xIn,yIn,result,overflow);
		
		// SUB Operation
		xIn = 8'b0010_0010; yIn = 8'b1110_0000; carry_in = 1'b0; opcode =3'b100;
		#20 $display("\n SUB Operation");
		#20	$display("Input1 = %b Input2 = %b Output = %b Overflow = %b ",xIn,yIn,result,overflow);
		
		// OR Operation
		xIn = 8'b0010_0011; yIn = 8'b1010_0000; carry_in = 1'b0; opcode = 3'b011;
		#25 $display("\n OR Operation");
		#25	$display("Input1 = %b Input2 = %b Output = %b Overflow = %b ",xIn,yIn,result,overflow);
		
		// MOV operation
		xIn = 8'b0010_0010; yIn = 8'b1110_0000; carry_in = 1'b0; opcode = 3'b000;
		#30 $display("\n MOV Operation");
		#30	$display("Input1 = %b Input2 = %b Output = %b Overflow = %b ",xIn,yIn,result,overflow);
	
		
	end	
	
endmodule


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