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
//0316044_0316225
module Decoder(
   instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	BranchType_o, // not set yet
	Jump_o,
	MemRead_o,
	MemWrite_o,
	MemtoReg_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;
output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output [1:0]   BranchType_o;
output			Jump_o;
output			MemRead_o;
output			MemWrite_o;
output [1:0]	MemtoReg_o;
//Internal Signals
reg            RegWrite_o;
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegDst_o;
reg            Branch_o;
reg	[1:0]    BranchType_o;
///
reg				Jump_o;// when Jump=1, j instruction
reg				MemRead_o;
reg				MemWrite_o;
reg	[1:0]		MemtoReg_o;
//Parameters


//Main function
always @(*) begin
    case (instr_op_i)
		  6'b100011: begin // lw
				RegWrite_o = 1;
				ALU_op_o = 3'd0;//+
            ALUSrc_o = 1;
            RegDst_o = 0;
            Branch_o = 0;
				BranchType_o = 2'bxx;
				Jump_o = 0;
				MemRead_o = 1;
				MemWrite_o = 0;
				MemtoReg_o = 2'd1;
		  end
		  6'b101011: begin // sw
				RegWrite_o = 0;
				ALU_op_o = 3'd0;//+
            ALUSrc_o = 1;
            RegDst_o = 1'bx;
            Branch_o = 0;
				BranchType_o = 2'bxx;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 1;
				MemtoReg_o = 2'bxx;
		  end
		  6'b000010: begin // jump
				RegWrite_o = 0;
				ALU_op_o = 3'bxxx; //?
            ALUSrc_o = 1'bx;
            RegDst_o = 1'bx;
            Branch_o = 0;
				BranchType_o = 2'bxx;
				Jump_o = 1;
				MemRead_o = 0;
				MemWrite_o = 0;
				MemtoReg_o = 2'bxx;
		  end
		  6'd6: begin // ble <=
            RegWrite_o = 0;
				ALU_op_o = 3'b001;
            ALUSrc_o = 0;
            RegDst_o = 1'bx; 
            Branch_o = 1;
				BranchType_o = 2'd2;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 0;
				MemtoReg_o = 2'bxx; 
        end
		  6'd1: begin // bltz <
            RegWrite_o = 0;
				ALU_op_o = 3'b001;
            ALUSrc_o = 0;
            RegDst_o = 1'bx; 
            Branch_o = 1;
				BranchType_o = 2'd3;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 0;
				MemtoReg_o = 2'bxx; 
        end
//=================================
		  6'd4: begin // beq == 
            RegWrite_o = 0;
				ALU_op_o = 3'b001;
            ALUSrc_o = 0;
            RegDst_o = 1'bx; 
            Branch_o = 1;
				BranchType_o = 2'd0;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 0;
				MemtoReg_o = 2'bxx; 
        end
        6'd5: begin // bne !=
            RegWrite_o = 0;
            ALU_op_o = 3'b001;//011;
            ALUSrc_o = 0;
            RegDst_o = 1'bx;
            Branch_o = 1;
				BranchType_o = 2'd1;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 0;
				MemtoReg_o = 2'bxx; 
        end
//====================================
        6'd0: begin // R-type
            RegWrite_o = 1;
				ALU_op_o = 3'b010;
            ALUSrc_o = 0;
            RegDst_o = 1;
            Branch_o = 0;
				BranchType_o = 2'bxx;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 0;
				MemtoReg_o = 2'b00;
        end
        6'd8: begin // addi
            RegWrite_o = 1;            
				ALU_op_o = 3'b000;
            ALUSrc_o = 1;
            RegDst_o = 0;
            Branch_o = 0;
				BranchType_o = 2'bxx;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 0;
				MemtoReg_o = 2'b00;
        end
		  6'd9: begin // sltiu
            RegWrite_o = 1;           
				ALU_op_o = 3'b111;
            ALUSrc_o = 1;
            RegDst_o = 0;
            Branch_o = 0;
				BranchType_o = 2'bxx;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 0;
				MemtoReg_o = 2'b00;
        end
        6'd10: begin // slti 
            RegWrite_o = 1;           
				ALU_op_o = 3'b100;
            ALUSrc_o = 1;
            RegDst_o = 0;
            Branch_o = 0;
				BranchType_o = 2'bxx;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 0;
				MemtoReg_o = 2'b00;
        end
        6'd15: begin // lui
            RegWrite_o = 1;
				ALU_op_o = 3'b101;
            ALUSrc_o = 1;
            RegDst_o = 0;
            Branch_o = 0;
				BranchType_o = 2'bxx;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 0;
				MemtoReg_o = 2'b00;
        end
        6'd13: begin // ori
            RegWrite_o = 1;
				ALU_op_o = 3'b110;
            ALUSrc_o = 1;
            RegDst_o = 0;
            Branch_o = 0;
				BranchType_o = 2'bxx;
				Jump_o = 0;
				MemRead_o = 0;
				MemWrite_o = 0;
				MemtoReg_o = 2'b00;
        end
        default: begin
            RegWrite_o = 1'bx;
				ALU_op_o = 3'bxxx;
            ALUSrc_o = 1'bx;
            RegDst_o = 1'bx;
            Branch_o = 1'bx;
				BranchType_o = 2'bxx;
				Jump_o = 1'bx;
				MemRead_o = 1'bx;
				MemWrite_o = 1'bx;
				MemtoReg_o = 2'bxx;
        end
    endcase
end
endmodule
                    
