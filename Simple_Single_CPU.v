//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
//KIWI p.24
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
//PC
reg	[32-1:0] pc_in;	//PC
reg	[32-1:0] pc_out;	//PC
reg	[32-1:0] pc_add_4;	//output of Adder1
reg	[32-1:0] pc_branch;	//output of Adder2
reg	[32-1:0] pc_shift_left_2;//output of shift_left_2,input of Adder2


reg	[32-1:0] instr;	//32-bit the instruction to conduct
//Decoder, OP code
reg	[3-1:0] 	ALU_op;
reg	RegWrite;
reg	ALUSrc;
reg	RegDst;
reg	Branch;
//Register File
reg	[5-1:0] 	write_reg;//input of RF, output of MUX_reg_write
reg	[32-1:0]	read_data_1;
reg	[32-1:0]	read_data_2;
reg	[32-1:0]	write_data;
//ALU Control, Function field
reg	[4-1:0] 	ALUCtrl;
reg	[32-1:0]	ALU_src2;//out of MUX
//Sign Extend
reg	[32-1:0]	constant;//output of SE,in of MUX_ALU & Shift_left_2
//ALU

reg	ALUZero;


//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_in) ,   
	    .pc_out_o(pc_out) 
	    );
	
Adder Adder1(	//PC add 4
        .src1_i(pc_out),     
	    .src2_i(32'd4),     
	    .sum_o(pc_add_4)
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(instr)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),	//rt
        .data1_i(instr[15:11]),	//rd
        .select_i(RegDst),
        .data_o(write_reg)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instr[25:21]) ,  
        .RTaddr_i(instr[20:16]) ,  
        .RDaddr_i(write_reg) ,  //5-bit
        .RDdata_i(write_data)  , 	//input, the data which go to destination
        .RegWrite_i (RegWrite),
        .RSdata_o(read_data_1) ,  //output, rs's data
        .RTdata_o(read_data_2)   //output, rt's data
        );
	
Decoder Decoder(	//OP code, first 6 bits of instruction
        .instr_op_i(instr[31:26]), //6-bit
	    .RegWrite_o(RegWrite), 
	    .ALU_op_o(ALU_op),   //3-bit, input of ALU Control
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),   
		.Branch_o(Branch)   
	    );

ALU_Ctrl AC(	//Function field, last 6 bits of instruction
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALU_op),   // 3-bit
        .ALUCtrl_o(ALUCtrl) //4-bit
        );
	
Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(constant)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(read_data_2),
        .data1_i(constant),
        .select_i(ALUSrc),
        .data_o(ALU_src2)
        );	
		
ALU ALU(
        .src1_i(read_data_1),
	    .src2_i(ALU_src2),
	    .ctrl_i(ALUCtrl),
	    .result_o(),
		.zero_o(ALUZero)
	    );
		
Adder Adder2(	//PC Branch / Jump
        .src1_i(pc_add_4),     
	    .src2_i(pc_shift_left_2),     
	    .sum_o(pc_branch)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(constant),
        .data_o(pc_shift_left_2)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_add_4),
        .data1_i(pc_branch),
        .select_i(Branch & ALUZero),
        .data_o(pc_in)
        );	

endmodule
		  


