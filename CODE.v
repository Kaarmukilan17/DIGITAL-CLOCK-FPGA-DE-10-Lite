module digital_clock(
    input wire clk,
    input wire reset,
    input wire mode_switch,
    input wire button_hours,
    input wire button_minutes,
    input wire hour_mode_switch,
    input wire time_zone_switch,
    output reg [6:0] seg0,
    output reg [6:0] seg1,
    output reg [6:0] seg2,
    output reg [6:0] seg3,
    output reg [6:0] seg4,
    output reg [6:0] seg5
);

    parameter DIVISOR = 50000000;

    reg [25:0] clk_divider = 0;
    reg one_sec_pulse = 0;
    reg [5:0] seconds = 0;
    reg [5:0] minutes = 0;
    reg [4:0] hours = 0;

    // Clock Divider: Generates a 1-second pulse from the 50 MHz clock
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

    // Time setting functionality
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hours <= 0;
            minutes <= 0;
            seconds <= 0;
        end else if (mode_switch) begin
            // Time Setting Mode: Allows manual adjustment of hours and minutes
            if (button_hours) begin
                if (hours == 23) 
                    hours <= 0;
                else
                    hours <= hours + 1;
            end

            if (button_minutes) begin
                if (minutes == 59)
                    minutes <= 0;
                else
                    minutes <= minutes + 1;
            end
        end
        else if (one_sec_pulse) begin
            // Normal clock operation: Handles the time progression in the background
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

    // Time Zone Adjustment: +2 hours when time_zone_switch is active
    wire [4:0] adjusted_hours;
    assign adjusted_hours = (time_zone_switch) ? ((hours + 2) % 24) : hours;

    // 12/24 Hour Mode Switch: Determines how the hours are displayed
    wire [4:0] display_hours;
    assign display_hours = (hour_mode_switch && (adjusted_hours == 0)) ? 5'd12 :
                           (hour_mode_switch && (adjusted_hours > 12)) ? (adjusted_hours - 12) : 
                           (hour_mode_switch && (adjusted_hours == 12)) ? 5'd12 :
                           adjusted_hours;

    // 7-Segment Display Decoder
    function [6:0] seven_segment_decoder;
        input [3:0] digit;
        case (digit)
            4'd0: seven_segment_decoder = 7'b1000000;
            4'd1: seven_segment_decoder = 7'b1111001;
            4'd2: seven_segment_decoder = 7'b0100100;
            4'd3: seven_segment_decoder = 7'b0110000;
            4'd4: seven_segment_decoder = 7'b0011001;
            4'd5: seven_segment_decoder = 7'b0010010;
            4'd6: seven_segment_decoder = 7'b0000010;
            4'd7: seven_segment_decoder = 7'b1111000;
            4'd8: seven_segment_decoder = 7'b0000000;
            4'd9: seven_segment_decoder = 7'b0010000;
            default: seven_segment_decoder = 7'b1111111;
        endcase
    endfunction

    always @(*) begin
        seg0 = seven_segment_decoder(seconds % 10);
        seg1 = seven_segment_decoder(seconds / 10);
        seg2 = seven_segment_decoder(minutes % 10);
        seg3 = seven_segment_decoder(minutes / 10);
        seg4 = seven_segment_decoder(display_hours % 10);
        seg5 = seven_segment_decoder(display_hours / 10);
    end

endmodule
