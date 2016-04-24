//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
//KIWI, p.22 P.30
//chp2,p.59
module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;


//beq=>001,sub(0110)
//lw/sw=>000,add(0010)
//r-type=>010,+function field
	//add 0010
	//sub 0110
	//and 0000
	//or 0001
	//slt 0111
	
//Parameter
//Main function
always@(*)begin
case(instr_op_i)
	6'd0:begin	//R-format: ADD, SUB, AND, OR, SLT+ SRA,SRAV
		RegWrite_o = 1;
		ALU_op_o = 3'b010;//2
		ALUSrc_o = 0;
		RegDst_o = 1;	//destination reg = rd
		Branch_o = 0;
		end
	6'd8:begin	//ADDI
		RegWrite_o = 1;
		ALU_op_o = 3'b011;//3
		ALUSrc_o = 1;	
		RegDst_o = 0;	//destination reg = rt
		Branch_o = 0;
		end
	6'd9:begin	//SLTIU
		RegWrite_o = 1;
		ALU_op_o = 3'b100;//4
		ALUSrc_o = 1;	
		RegDst_o = 0;	//destination reg = rt
		Branch_o = 0;
		end
	6'd4:begin	//BEQ
		RegWrite_o = 0;
		ALU_op_o = 3'b001;//1
		ALUSrc_o = 0;
		RegDst_o = 0;//Don'd care
		Branch_o = 1;
		end
	/*6'd15:begin	//LUI
		RegWrite_o = 0;
		ALU_op_o = 3'b101;//5
		ALUSrc_o = 0;
		RegDst_o = 0;//Don'd care
		Branch_o = 1;
		end
	6'd13:begin	//ORI
		RegWrite_o = 0;
		ALU_op_o = 3'b110;//6
		ALUSrc_o = 0;
		RegDst_o = 0;//Don'd care
		Branch_o = 1;
		end
	6'd5:begin	//BNE
		RegWrite_o = 0;
		ALU_op_o = 3'b111;//7
		ALUSrc_o = 0;
		RegDst_o = 0;//Don'd care
		Branch_o = 1;
		end*/
	default	;
endcase
end
endmodule





                    
                    