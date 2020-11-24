// ADD CODE BELOW
// Add code for the condlogic and condcheck modules. Remember, you may
// reuse code from prior labs.
module condlogic (
	clk,
	reset,
	Cond,
	ALUFlags,
	FlagW,
	PCS,
	NextPC,
	RegW,
	MemW,
	PCWrite,
	RegWrite,
	MemWrite
);
	input wire clk;
	input wire reset;
	input wire [3:0] Cond;
	input wire [3:0] ALUFlags;
	input wire [1:0] FlagW;
	input wire PCS;
	input wire NextPC;
	input wire RegW;
	input wire MemW;
	output wire PCWrite;
	output wire RegWrite;
	output wire MemWrite;
    
	wire [1:0] FlagWrite;
	wire [3:0] Flags;
	wire CondEx;
    wire CondexOut;

	// Delay writing flags until ALUWB state
	// flopr #(1) flagwritereg(
	// 	.clk(clk),
	// 	.reset(reset),
	// 	.d(FlagW & {2 {CondEx}}),
	// 	.d(FlagWrite)
	// );

	// Flags
    flopenr #(2) ALUFlags0(
        .clk(clk),
        .reset(reset),
        .en(FlagWrite[0]),
        .d(ALUFlags[1:0]),
        .q(Flags[1:0])
    );

    flopenr #(2) ALUFlags1(
        .clk(clk),
        .reset(reset),
        .en(FlagWrite[1]),
        .d(ALUFlags[3:2]),
        .q(Flags[3:2])
    );
    condcheck cc(
		.Cond(Cond),
		.Flags(Flags),
		.CondEx(CondEx)
	);
    
    flopr #(1) condexdelay(
        .clk(clk),
        .reset(reset),
        .d(CondEx),
        .q(CondexOut)
    );

    assign FlagWrite = FlagW & {2 {CondEx}};
    assign RegWrite = RegW & CondexOut;
	assign MemWrite = MemW & CondexOut;
	assign PCSrc = (PCS & CondEx) | NextPC;
endmodule