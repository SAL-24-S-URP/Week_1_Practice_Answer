interface FSM_INTF
#(
    parameter   CNT_WIDTH      = 4
)
(
    input                       clk
);
    
    logic                       start;
    logic                       done;
    
    semaphore                   sema;
    initial begin
        sema                    = new(1);
    end

    modport master (
        input           clk,
        input           done,

        output          start
    );

    task init();
        start           = 1'b0;
    endtask

    task automatic start_fsm();
        sema.get(1);

        #1
        start           = 1'b1;
        @(posedge clk);
        start           = 1'b0;
        

        while (done == 1'b0) begin
            @(posedge clk);
        end

        sema.put(1);
    endtask
    
endinterface