module sent_tx_pulse_gen(
    input clk_tx,
    input ticks_i,
    input reset_n_tx,

    input [3:0] data_nibble_i,
    input pulse_i,
    input sync_i,
    input pause_i,
    input idle_i,
    output reg pulse_done_o,

    output reg sent_tx_o
);

    reg sig_ticks; //saved pre ticks
    reg [10:0] count_ticks_i;
    reg [15:0] count;
    reg [3:0] count_zero_idle;

    always @(posedge clk_tx or negedge reset_n_tx) begin
        if (!reset_n_tx) begin
            count <= 0;
            sig_ticks <= 0;
            count_ticks_i <= 0;
            count_zero_idle <= 0;
            pulse_done_o <= 0;
            sent_tx_o <= 1;
        end else begin
            sig_ticks <= ticks_i;

            if (pulse_done_o) pulse_done_o <= 0; //Turn off at next posedge clk_tx

            if (ticks_i == 1 && sig_ticks == 0) begin // detect posedge ticks_i
                count <= count + 1;

                case (1'b1)
                    sync_i: begin
                        if (count > 5) begin
                            sent_tx_o <= 1; // after 6 ticks, sent_tx_output hold '1'
                            if (count == 56) begin // sync is 56 ticks
                                sent_tx_o <= 0;
                                pulse_done_o <= 1; // done state sync
                                count <= 1;
                                count_ticks_i <= count_ticks_i + 56; // count number of ticks in this state
                            end
                        end else begin
                            sent_tx_o <= 0; // initial fixed logic '0' in 6 ticks
                        end
                        count_zero_idle <= 0;
                    end

                    pulse_i: begin
                        if (count > 5) begin
                            sent_tx_o <= 1; // after 6 ticks, sent_tx_output hold '1'
                            if (count == 12 + data_nibble_i) begin // status, data, crc 0-27 ticks
                                sent_tx_o <= 0;
                                pulse_done_o <= 1;
                                count <= 1;
                                count_ticks_i <= count_ticks_i + 12 + data_nibble_i; // count number of ticks in this state
                            end
                        end else begin
                            sent_tx_o <= 0;
                        end
                    end

                    pause_i: begin
                        if (count > 5) begin
                            sent_tx_o <= 1; // after 6 ticks, sent_tx_output hold '1'
                            if (count == 280 - count_ticks_i) begin // 1 frame fixed 280 ticks
                                sent_tx_o <= 0;
                                pulse_done_o <= 1;
                                count <= 1;
                                count_ticks_i <= 0;
                            end
                        end else begin
                            sent_tx_o <= 0;
                        end
                    end

                    idle_i: begin
                        count <= 0;
                        if (count_zero_idle == 4) begin // negedge and posedge is 4 ticks, announce stop
                            sent_tx_o <= 1; // sent_tx_o hold '1' until next enable
                        end else begin
                            count_zero_idle <= count_zero_idle + 1;
                            sent_tx_o <= 0;
                        end
                    end

                    default: begin
                        // Do nothing if no valid input signals
                    end
                endcase
            end
        end
    end
endmodule

