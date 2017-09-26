module testMUX;
	wire [7:0]OUTData;
	reg [7:0]InData_1;
	
	Compliment2 comp(InData_1, OUTData);
	initial begin
		InData_1 = 8'b0010_1111; 
		$monitor("OUTPUT : %b",OUTData);
	end
	
	initial
		#100 $finish;
		
endmodule




module Compliment2(InData_1, OUTData);
	
	input [7:0]InData_1;		
	output [7:0]OUTData;
	reg [7:0]temp;
	
	initial@(temp,InData_1) begin
			temp = ~InData_1 + 1'b1;		
	end
	assign OUTData = temp;
	
endmodule