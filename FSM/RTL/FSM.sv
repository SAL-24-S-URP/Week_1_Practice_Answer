// Copyright (c) 2024 Sungkyunkwan University
//
// Authors:
// - Sanghyun Park <psh2018314072@gmail.com>


module FSM
(
    input   wire                    clk,
    input   wire                    rst_n,

    input   wire                    start_i,
    output  wire                    done_o
);

    localparam  S_IDLE          = 2'b00;
    localparam  S_RUN           = 2'b01;
    localparam  S_DONE          = 2'b10;

    reg     [1:0]               state,      state_n;
    reg                         done;
    
    always_ff @(posedge clk) begin
        if(!rst_n) begin
            state               <= S_IDLE;
        end else begin
            state               <= state_n;
        end
    end

    always_comb begin
        done                    = 1'b0;
        state_n                 = state;

        case(state)
            S_IDLE: begin
                if(start_i) begin
                    state_n     = S_RUN; 
                end
            end

            S_RUN: begin
                state_n         = S_DONE; 
            end

            S_DONE: begin
                done            = 1'b1;
                state_n         = S_IDLE;
            end

        endcase
    end

    assign  done_o              = done;

endmodule