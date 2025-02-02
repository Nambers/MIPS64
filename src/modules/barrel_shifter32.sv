// an alternative basic barrel shifter implementation
// module barrel_shifter32 #(
//     parameter width = 32
// )(
//     output wire [width - 1:0] data_out,
//     input wire [width - 1:0] data_in,
//     input wire [4:0] shift_amount,
//     input wire direction // 0 for left, 1 for right
// );

//     wire [width - 1:0] w10, w11, w20, w21, w30, w31, w40, w41, w50;

//     // Stage 1: Shift by 0 or 1
//     mux2v #(width) mux2v_0(
//         w10,
//         {data_in[width-2:0], 1'b0},
//         {1'b0, data_in[width-1:1]},
//         direction
//     );
//     mux2v #(width) mux2v_1(w11, data_in, w10, shift_amount[0]);

//     // Stage 2: Shift by 0 or 2
//     mux2v #(width) mux2v_2(
//         w20,
//         {w11[width-3:0], 2'b0},
//         {2'b0, w11[width-1:2]} ,
//         direction
//     );
//     mux2v #(width) mux2v_3(w21, w11, w20, shift_amount[1]);

//     // Stage 3: Shift by 0 or 4
//     mux2v #(width) mux2v_4(
//         w30,
//         {w21[width-5:0], 4'b0},
//         {4'b0, w21[width-1:4]} ,
//         direction
//     );
//     mux2v #(width) mux2v_5(w31, w21, w30, shift_amount[2]);

//     // Stage 4: Shift by 0 or 8
//     mux2v #(width) mux2v_6(
//         w40,
//         {w31[width-9:0], 8'b0},
//         {8'b0, w31[width-1:8]},
//         direction
//     );
//     mux2v #(width) mux2v_7(w41, w31, w40, shift_amount[3]);

//     // Stage 5: Shift by 0 or 16
//     mux2v #(width) mux2v_8(
//         w50,
//         {w41[width-17:0], 16'b0},
//         {16'b0, w41[width-1:16]},
//         direction
//     );
//     mux2v #(width) mux2v_9(data_out, w41, w50, shift_amount[4]);

// endmodule

module barrel_shifter32 #(
    parameter width = 32
)(
    output wire [width - 1:0] data_out,
    input wire [width - 1:0] data_in,
    input wire [4:0] shift_amount,
    input wire direction // 0 for left, 1 for right
);
    assign data_out = (direction == 0) ? data_in << shift_amount : data_in >> shift_amount;
endmodule
