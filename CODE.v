module digital_clock(
    input wire clk, // 50 MHz clock input on DE10 board
    input wire reset, // Reset signal
    input wire button1, // Button 1 to increment hours
    input wire button2, // Button 2 to decrement hours
    output reg [6:0] seg0, // 7-segment display segments for seconds (ones)
    output reg [6:0] seg1, // 7-segment display segments for seconds (tens)
    output reg [6:0] seg2, // 7-segment display segments for minutes (ones)
    output reg [6:0] seg3, // 7-segment display segments for minutes (tens)
    output reg [6:0] seg4, // 7-segment display segments for hours (ones)
    output reg [6:0] seg5 // 7-segment display segments for hours (tens)
);

    // Clock Divider Parameters
    parameter DIVISOR = 50000000; // Divide 50MHz to 1Hz for seconds

    // Registers for clock divider, counters
    reg [25:0] clk_divider = 0;
    reg one_sec_pulse = 0;
    reg [5:0] seconds = 0; // 0-59 for seconds
    reg [5:0] minutes = 0; // 0-59 for minutes
    reg [4:0] hours = 0; // 0-23 for hours

    // Clock Divider to generate 1-second pulse
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_divider <= 0;
            one_sec_pulse <= 0;
        end else begin
            if (clk_divider == DIVISOR - 1) begin
                clk_divider <= 0;
                one_sec_pulse <= 1;
            end else begin
                clk_divider <= clk_divider + 1;
                one_sec_pulse <= 0;
            end
        end
    end

    // Button press handling for time setting (Increment and Decrement hours)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hours <= 0; // Reset hours
        end else begin
            // Button 1 to increment hours
            if (button1) begin
                if (hours == 23)
                    hours <= 0; // Wrap around to 0 if hours reach 23
                else
                    hours <= hours + 1;
            end
            // Button 2 to decrement hours
            if (button2) begin
                if (hours == 0)
                    hours <= 23; // Wrap around to 23 if hours reach 0
                else
                    hours <= hours - 1;
            end
        end
    end

    // Seconds, Minutes, and Hours Counters
    always @(posedge clk) begin
        if (reset) begin
            seconds <= 0;
            minutes <= 0;
            hours <= 0;
        end else if (one_sec_pulse) begin
            if (seconds == 59) begin
                seconds <= 0;
                if (minutes == 59) begin
                    minutes <= 0;
                    if (hours == 23)
                        hours <= 0;
                    else
                        hours <= hours + 1;
                end else begin
                    minutes <= minutes + 1;
                end
            end else begin
                seconds <= seconds + 1;
            end
        end
    end

    // 7-Segment Display Decoder
    function [6:0] seven_segment_decoder;
        input [3:0] digit;
        begin
            case (digit)
                4'd0: seven_segment_decoder = 7'b1000000; // 0
                4'd1: seven_segment_decoder = 7'b1111001; // 1
                4'd2: seven_segment_decoder = 7'b0100100; // 2
                4'd3: seven_segment_decoder = 7'b0110000; // 3
                4'd4: seven_segment_decoder = 7'b0011001; // 4
                4'd5: seven_segment_decoder = 7'b0010010; // 5
                4'd6: seven_segment_decoder = 7'b0000010; // 6
                4'd7: seven_segment_decoder = 7'b1111000; // 7
                4'd8: seven_segment_decoder = 7'b0000000; // 8
                4'd9: seven_segment_decoder = 7'b0010000; // 9
                default: seven_segment_decoder = 7'b1111111; // blank
            endcase
        end
    endfunction

    // Assigning segments to corresponding digits
    always @(*) begin
        // Decode seconds
        seg0 = seven_segment_decoder(seconds % 10); // ones digit of seconds
        seg1 = seven_segment_decoder(seconds / 10); // tens digit of seconds

        // Decode minutes
        seg2 = seven_segment_decoder(minutes % 10); // ones digit of minutes
        seg3 = seven_segment_decoder(minutes / 10); // tens digit of minutes

        // Decode hours
        seg4 = seven_segment_decoder(hours % 10); // ones digit of hours
        seg5 = seven_segment_decoder(hours / 10); // tens digit of hours
    end

endmodule
