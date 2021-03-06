module ForwardUnit(
    input[5:0] Opcode,
    input[4:0] RsAddr_IFID,
    input[4:0] RtAddr_IFID,
    input[4:0] RsAddr_IDEX,
    input[4:0] RtAddr_IDEX,
    input[4:0] RdAddr_EXMEM,
    input[4:0] RdAddr_MEMWB,
    input RegWrite_EXMEM,
    input RegWrite_MEMWB,
    //input MemRead_IDEXE,
    output reg [1:0] ForwardA, //ALU-Rs
    output reg [1:0] ForwardB, //ALU_Rt
    output reg ForwardC,       //CMP1Rs
    output reg ForwardD,       //CMP1Rt
    output reg ForwardE        //CMP2Rs
);

initial
begin
    ForwardA <= 2'b00;
    ForwardB <=2'b00;
    ForwardC <= 0;
    ForwardD <= 0;
    ForwardE <= 0;
end

always @(*) begin
    ForwardA <= 2'b00;
    ForwardB <= 2'b00;
    ForwardC <= 0;
    ForwardD <= 0;
    ForwardE <= 0;
    //Data Forward
    if (RegWrite_EXMEM && (RdAddr_EXMEM != 0) && (RdAddr_EXMEM == RsAddr_IDEX)) begin
        ForwardA <= 2'b01; //EXEMEM to EXE Rs
	$display("A EX Forward to Rs");
    end
    if (RegWrite_EXMEM && (RdAddr_EXMEM != 0) && (RdAddr_EXMEM == RtAddr_IDEX)) begin
        ForwardB <= 2'b01; //EXEMEM to EXE Rt
	$display("A EX Forward to Rt");
    end
    if (RegWrite_MEMWB && (RdAddr_MEMWB != 0) && !(RegWrite_EXMEM && (RdAddr_EXMEM != 0) && (RdAddr_EXMEM == RsAddr_IDEX)) && (RdAddr_MEMWB == RsAddr_IDEX)) begin
        ForwardA <= 2'b10; //MEMWB to EXE Rs
	$display("A MEM Forward to Rs");
    end
    if(RegWrite_MEMWB && (RdAddr_MEMWB != 0) && !(RegWrite_EXMEM && (RdAddr_EXMEM != 0) && (RdAddr_EXMEM == RtAddr_IDEX)) && (RdAddr_MEMWB == RtAddr_IDEX)) begin
        ForwardB <= 2'b10; //MEMWB to EXE Rt
	$display("A MEM Forward to Rt");
    end

    //Bracnch Forward
    if (RegWrite_EXMEM && (RdAddr_EXMEM != 0) && (RdAddr_EXMEM == RsAddr_IFID) && (Opcode == 6'h04 || Opcode == 6'h05)) begin
        ForwardC <= 1;
    end
    if(RegWrite_EXMEM && (RdAddr_EXMEM != 0) && (RdAddr_EXMEM == RtAddr_IFID) && (Opcode == 6'h04 || Opcode == 6'h05)) 
        ForwardD <= 1;
    
    if (RegWrite_EXMEM && (RdAddr_EXMEM != 0) && (RdAddr_EXMEM == RsAddr_IFID) && (Opcode == 6'h01 || Opcode == 6'h06 || Opcode == 6'h07)) begin
        ForwardE <= 1;
    end


end

endmodule // ForwardUnit