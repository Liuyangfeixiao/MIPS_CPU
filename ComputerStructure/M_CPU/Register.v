module Register(clk,WriteSignal,in,out);
    input clk;
    input WriteSignal;
    input[31:0] in;
    output reg [31:0] out;

    always@(negedge clk)//鍐欏叆鍦ㄤ笅闄嶆部
        begin
            out <= (WriteSignal == 1) ? in : out;
        end
endmodule