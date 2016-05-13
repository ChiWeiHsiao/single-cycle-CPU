//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
//0316044_0316225
module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	shamt,
	result_o,
	zero_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;
input	 [5-1:0] 	shamt;//instr[10:6]

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;

//Parameter
assign zero_o = (ctrl_i==8)?(result_o!=0):(result_o==0);
//Main function
always @(ctrl_i, src1_i, src2_i) begin
   case(ctrl_i)
	   0: result_o <= src1_i & src2_i;
		1: result_o <= src1_i | src2_i;
		2: result_o <= src1_i + src2_i;
		3: result_o <= src1_i * src2_i;
		6: result_o <= src1_i - src2_i;
		7: result_o <= src1_i < src2_i ? 1:0;
		8: result_o <= src1_i - src2_i;//BRANCH ON NOT EQUAL
		9: result_o <= ($signed(src2_i) >>> shamt);//SRA
		11:result_o <= ($signed(src2_i) >>> $signed(src1_i));//SRA V 
		12: result_o <= ~(src1_i | src2_i);
		13: result_o <= {16'd0,src1_i[15:0]} < {16'd0,src2_i[15:0]} ?1:0;
		14: result_o <= (src2_i << 16);//lui
		default: result_o <= 0;
	endcase
end
endmodule
