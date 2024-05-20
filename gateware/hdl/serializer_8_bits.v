`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JQI
// Engineer: Alessandro restelli
// 
// Create Date: 02/06/2024 12:55:07 PM
// Design Name: 
// Module Name: serializer_8_bits
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module serializer_8_bits(

            slow_clock, //To be connected to 156.25 MHz
            fast_clock, //To be connected to 625MHz. Thanks to the dual data rate
                        //the output data rate will be 1.25GHz
            rst, //reset            
            
            parallel_input, //8 bit register
            single_ended_out
            
            //serial_output_p,
            //serial_output_n //differential node
            );
                    
    
    input slow_clock, fast_clock,rst;
    input [7:0] parallel_input;
    //output serial_output_p, serial_output_n;
    
    output single_ended_out;
    //wire single_ended_out;
    
    //assign serial_monitor=single_ended_out;
    
    //the instructions to use the serializer are at page 162 here:
    //https://www.xilinx.com/support/documentation/user_guides/ug471_7Series_SelectIO.pdf
    
    
    // OSERDESE2: Output SERial/DESerializer with bitslip
       //            Artix-7
       // Xilinx HDL Language Template, version 2018.1
    
       OSERDESE2 #(
          .DATA_RATE_OQ("DDR"),   // DDR, SDR
          .DATA_RATE_TQ("DDR"),   // DDR, BUF, SDR
          .DATA_WIDTH(8),         // Parallel data width (2-8,10,14)
          .INIT_OQ(1'b0),         // Initial value of OQ output (1'b0,1'b1)
          .INIT_TQ(1'b0),         // Initial value of TQ output (1'b0,1'b1)
          .SERDES_MODE("MASTER"), // MASTER, SLAVE
          .SRVAL_OQ(1'b0),        // OQ output value when SR is used (1'b0,1'b1)
          .SRVAL_TQ(1'b0),        // TQ output value when SR is used (1'b0,1'b1)
          .TBYTE_CTL("FALSE"),    // Enable tristate byte operation (FALSE, TRUE)
          .TBYTE_SRC("FALSE"),    // Tristate byte source (FALSE, TRUE)
          .TRISTATE_WIDTH(1)      // 3-state converter width (1,4)
                                  // Please note that when DATA_WIDTH is greater than 4
                                  // The TRISTATE_WIDTH parameter must be set to 1
          
          
          
       )
       OSERDESE2_for_laser (
          //.OFB(serial_monitor),             // 1-bit output: Feedback path for data
          .OQ(single_ended_out),               // 1-bit output: Data path output
          // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
          //.SHIFTOUT1(SHIFTOUT1),
          //.SHIFTOUT2(SHIFTOUT2),
          //.TBYTEOUT(TBYTEOUT),   // 1-bit output: Byte group tristate
          //.TFB(TFB),             // 1-bit output: 3-state control
          //.TQ(TQ),               // 1-bit output: 3-state control
          .CLK(fast_clock),             // 1-bit input: High speed clock
          .CLKDIV(slow_clock),       // 1-bit input: Divided clock
          // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
          .D1(parallel_input[0]),
          .D2(parallel_input[1]),
          .D3(parallel_input[2]),
          .D4(parallel_input[3]),
          .D5(parallel_input[4]),
          .D6(parallel_input[5]),
          .D7(parallel_input[6]),
          .D8(parallel_input[7]),
          .OCE(1'b1),             // 1-bit input: Output data clock enable
          .RST(rst),             // 1-bit input: Reset
          // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
          //.SHIFTIN1(SHIFTIN1),
          //.SHIFTIN2(SHIFTIN2),
          // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
          //.T1(T1),
          //.T2(T2),
          //.T3(T3),
          //.T4(T4),
          //.TBYTEIN(TBYTEIN),     // 1-bit input: Byte group tristate
          .TCE(1'b0)              // 1-bit input: 3-state clock enable
       );
    
       // End of OSERDESE2_inst instantiation
       
       

          // OBUFDS: Differential Output Buffer
          //         Artix-7
          // Xilinx HDL Language Template, version 2018.1
       /*
          OBUFDS #(
             .IOSTANDARD("DEFAULT"), // Specify the output I/O standard
             .SLEW("FAST")           // Specify the output slew rate
          ) OBUFDS_inst (
             .O(serial_output_p),     // Diff_p output (connect directly to top-level port)
             .OB(serial_output_n),   // Diff_n output (connect directly to top-level port)
             .I(single_ended_out)      // Buffer input
          );
*/
     
     
     
                           
endmodule