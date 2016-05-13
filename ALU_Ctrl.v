//Subject:     CO project 2 - ALU Controller
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
module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always @ (*) begin
  case (ALUOp_i)
	 3'd0: ALUCtrl_o = 4'd2; //add :for addi
    3'd1: ALUCtrl_o = 4'd6; //sub :for beq
    3'd2:
      case (funct_i)//R-type
			 6'd24: ALUCtrl_o = 4'd3;//Mul 
			 6'd36: ALUCtrl_o = 4'd0; //R-type AND
			 6'd37: ALUCtrl_o = 4'd1; //R-type OR
          6'd32: ALUCtrl_o = 4'd2; //R-type Add
          6'd34: ALUCtrl_o = 4'd6; //R-type Subtract
          6'd42: ALUCtrl_o = 4'd7; //R-type slt
          6'd3: ALUCtrl_o = 4'd9; // SRA ??
          6'd7: ALUCtrl_o = 4'd11; // SRA V ??
          default:   ALUCtrl_o = 4'bxxxx;
      endcase
			//3'd3: ALUCtrl_o = 4'd8; //BNE ?
    3'd4: ALUCtrl_o = 4'd7;	//slti
	 3'd5: ALUCtrl_o = 4'd14;	//lui 
    3'd6: ALUCtrl_o = 4'd1;	//ori
	 3'd7:	ALUCtrl_o <= 4'd13;//slti u
    default: ALUCtrl_o = 4'bxxxx;
  endcase
end

endmodule     





                    
                    
