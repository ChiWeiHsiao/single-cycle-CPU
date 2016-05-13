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
//0316044_0316225

module Simple_Single_CPU(
        clk_i,
		  rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;
//Internal Signles
//PC
wire	[32-1:0] pc_in;	//PC
wire	[32-1:0] pc_out;	//PC
wire	[32-1:0] pc_add_4;	//output of Adder1
wire	[32-1:0] pc_branch;	//output of Adder2
wire	[32-1:0] pc_shift_left_2;//output of shift_left_2,input of Adder2
wire	[32-1:0] instr;	//32-bit the instruction to conduct
//Decoder, OP code
wire	[3-1:0] 	ALU_op;
wire	RegWrite, ALUSrc, RegDst, Branch, Jump, MemRead, MemWrite;
wire	[1:0] MemtoReg;
wire	[1:0] BranchType;
//Register File
wire	[5-1:0] 	write_reg;//input of RF, output of MUX_reg_write
wire	[32-1:0]	read_data_1;
wire	[32-1:0]	read_data_2;
wire	[32-1:0]	ALU_result;
wire	[32-1:0] Reg_data_i;
//ALU Control, Function field
wire	[4-1:0] 	ALUCtrl;
wire	[32-1:0]	ALU_src2;//out of MUX
//Sign Extend
wire	[32-1:0]	constant;//output of SE,in of MUX_ALU & Shift_left_2
//ALU
wire	ALUZero;
//Mux_PC_Source
wire Mux_PC_Source_select;
//Data_Memory
wire DM_data_o;


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
        .RDdata_i(Reg_data_i)  , 	//input, the data which go to destination #?
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
		 .Branch_o(Branch),
		 .BranchType_o(BranchType),
		 .Jump_o(Jump),
		 .MemRead_o(MemRead),
		 .MemWrite_o(MemWrite),
		 .MemtoReg_o(MemtoReg)
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
		 .shamt(instr[10:6]),
	    .result_o(ALU_result),
		.zero_o(ALUZero)
	    );
//?		 
Data_Memory(
		.clk_i(clk_i),
		.addr_i(ALU_result),
		.data_i(read_data_2),
		.MemRead_i(MemRead),
		.MemWrite_i(MemWrite),
		.data_o(DM_data_o)
);

MUX_3to1 #(.size(32)) Mux_Reg_Source(
        .data0_i(ALU_result),
        .data1_i(DM_data_o),
		  .data2_i(constant),
        .select_i(MemtoReg),
        .data_o(Reg_data_i)
        );	
//?
Adder Adder2(	//PC Branch
        .src1_i(pc_add_4),     
	    .src2_i(pc_shift_left_2),     
	    .sum_o(pc_branch)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(constant),
        .data_o(pc_shift_left_2)
        ); 		

wire Branch_Type_o;
Branch_Type Branch_or_not(
	 .branch_type_i(BranchType),
    .alu_result_sign_bit_i(ALU_result[31]),
	 .alu_zero_i(ALUZero),
	 .branch_or_not_o(Branch_Type_o)
	 );

assign Mux_PC_Source_select = Branch & Branch_Type_o;

wire	[32-1:0]	pc1_data_o;
MUX_2to1 #(.size(32)) Mux_PC_Source1(
        .data0_i(pc_add_4),
        .data1_i(pc_branch),
        .select_i(Mux_PC_Source_select),
        .data_o(pc1_data_o)
        );	 

wire [27:0] jump_shift_left_o;
Shift_Left_Two_28 Shifter_Jump(
        .data_i(instr[25:0]),
        .data_o(jump_shift_left_o)
        ); 		

wire	[32-1:0]	pc2_jump;
MUX_2to1 #(.size(32)) Mux_PC_Source2(
        .data0_i(pc2_jump),
        .data1_i(pc1_data_o),
        .select_i(Jump),
        .data_o(pc_in)
        );	 
		  
endmodule
