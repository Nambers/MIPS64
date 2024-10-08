`define ALU_ADD    3'b010
`define ALU_SUB    3'b011
`define ALU_AND    3'b100
`define ALU_OR     3'b101
`define ALU_NOR    3'b110
`define ALU_XOR    3'b111

module adder(
    output wire out,
    output wire cout,
    input wire a,
    input wire b,
    input wire cin,
    input wire sub
);
    wire b_ = b ^ sub;
    // K-map
    // a b / c | 0 | 1
    //     0 0 |   | 1
    //     0 1 | 1 |  
    //     1 1 |   | 1
    //     1 0 | 1 |  
    // = a'b'c + a'bc' + abc + ab'c'
    // = c(a'b' + ab) + c'(a'b + ab')
    // = c(a Xnor b) + c'(a ^ b)
    // = c((a ^ b)') + c'(a ^ b)
    // = c ^ (a ^ b) = c ^ a ^ b
    assign out = a ^ b_ ^ cin;
    // K-map
    // a b / c | 0 | 1
    //     0 0 |   |  
    //     0 1 |   | 1
    //     1 1 | 1 | 1
    //     1 0 |   | 1
    // = ab + bc + ac
    assign cout = (a & b_) | (a & cin) | (b_ & cin);

endmodule

module lu #(
    parameter width = 32
) (
    input wire [width-1:0] a,
    input wire [width-1:0] b,
    input wire [1:0] lu_op,
    output wire [width-1:0] out
);
    mux4v #(width) mux4v_0(
        out,
        a & b,
        a | b,
        ~(a | b),
        a ^ b,
        lu_op
    );
endmodule

module au #(
    parameter width = 32
) (
    input wire [width-1:0] a,
    input wire [width-1:0] b,
    input wire sub,
    output wire [width-1:0] out,
    output wire negative,
    output wire zero,
    output wire overflow
);
    wire [width-1:0] c_out;
    adder adder_0(
        out[0],
        c_out[0],
        a[0],
        b[0],
        sub,
        sub
    );
    adder adder_gate[width-1:1](
        out[width-1:1],
        c_out[width-1:1],
        a[width-1:1],
        b[width-1:1],
        c_out[width-2:0],
        sub
    );
     
    assign negative = out[width-1];
    assign zero = ~|out;
    assign overflow = c_out[width-1] ^ c_out[width-2];
endmodule

module alu #(
    parameter width = 32
) (
    output wire [width-1:0] out,
    output wire overflow,
    output wire zero,
    output wire negative,
    input wire [width-1:0] a,
    input wire [width-1:0] b,
    input wire [2:0] alu_op
);

    wire [width-1:0] lu_out, au_out;
    lu #(width) lu_0(
        a,
        b,
        alu_op[1:0],
        lu_out
    );
    au #(width) au_0(
        a,
        b,
        alu_op[0],
        au_out,
        negative,
        zero,
        overflow
    );

    mux2v #(width) mux2v_0(
        out,
        au_out,
        lu_out,
        alu_op[2]
    );
endmodule