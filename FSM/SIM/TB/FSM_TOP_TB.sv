`define TIMEOUT_DELAY   500000
module FSM_TOP_TB ();
    reg                     clk;
    reg                     rst_n;

    // clock generation
    initial begin
        clk                     = 1'b0;

        forever #10 clk         = !clk;
    end


    // reset generation
    initial begin
        rst_n                   = 1'b0;     // active at time 0

        repeat (3) @(posedge clk);          // after 3 cycles,
        rst_n                   = 1'b1;     // release the reset
    end
    
    //timeout
    initial begin
        #`TIMEOUT_DELAY $display("Timeout!");
        $finish;
    end

    // enable waveform dump
    initial begin
        $dumpvars(0, u_DUT);
        $dumpfile("dump.vcd");
    end

    //----------------------------------------------------------
    // Connection between DUT and test modules
    //----------------------------------------------------------

    FSM_INTF                    #(.CNT_WIDTH(4))
                                fsm_if  (.clk(clk));
    FSM u_DUT (
        .clk                    (clk),
        .rst_n                  (rst_n),
        .start_i                (fsm_if.start),
        .done_o                 (fsm_if.done)
    );

    task test_init();
        fsm_if.init();
        @(posedge rst_n); 
        repeat (10) @(posedge clk);
    endtask


    task drive();
        fsm_if.start_fsm();
    endtask

    
    initial begin
        $display("/*----------------------*/");
        $display("  Start Simulation!");
        test_init();
        fork
            drive();
        join
        $display("  Simulation Done!");
        $display("/*----------------------*/");
        $finish;
    end

endmodule