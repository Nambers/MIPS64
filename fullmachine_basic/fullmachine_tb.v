module fullmachine_test;
    /* Make a regular pulsing clock. */
    reg       clk = 0;
    always #5 clk = !clk;
    integer     i;

    reg 		reset = 1, done = 0;
    wire         except;
    wire [31:0][63:0] reg_out;

    full_machine fm(
        .clock(clk),
        .reset(reset),
        .except(except),
        .debug_reg_out(reg_out)
    );
    
    initial begin
        `ifdef SIMULATION
            $display("Simulation mode - fullmachine_test");
        `endif
        $dumpfile("fullmachine.vcd");
        $dumpvars(0, fullmachine_test); // dump all variables except memories

        # 10 reset = 0; // wait a clock
        # 600 done = 1; // run x / 10 instructions
    end
   
    initial
        $monitor("At time %t, reset = %d pc = %h, inst = %h, except = %h",
                 $time, reset, fm.PC_reg.Q, fm.mem.inst, except);
    
    // periodically check for the end of simulation.  When it happens
    // dump the register file contents.
    always @(negedge clk)
    begin
        #0;
        if ((done === 1'b1) | (except === 1'b1))
        begin
            $display ( "Dumping register state: " );
            $display ( "  Register :  hex-value (  dec-value )" );
            for (i = 0; i < 32; i = i + 1) begin
                $display ( "%d: 0x%x ( %d )", i, reg_out[i], reg_out[i]);
            end
            $writememh("memory_after.txt", fm.mem.data_seg);
            $display ( "Done.  Simulation ending." );
            $finish;
        end
    end
   
endmodule // test
