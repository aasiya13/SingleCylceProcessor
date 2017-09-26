module testMUX;
	wire [7:0]OUTMux;
	reg [7:0]InMux;
	reg [7:0]InMux_2;
	reg select;
	
	MUX MUX_module(InMux, InMux_2, select, OUTMux);
	initial begin
		InMux = 8'b1010_0001; InMux_2 = 8'b0000_1111; select = 1'b0;
		$monitor("OUTPUT : %b",OUTMux);
	end
	
	initial
		#100 $finish;
		
endmodule


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
