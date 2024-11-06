
module top_module;         // top module is the one that contains "initial begin"
 
  reg  [0:9]rin1; reg [0:9]rin2;                // input arrays
  wire [0:9]final_carry; wire [0:9]final_sum;   // sum and carry
  wire [0:9]input_after_and;
  reg clk;                                      // clock signal
  
  //--------------------------------------------------------------------
  integer i;
  initial begin
    for (i = 0; i < 10; i = i + 1) begin
        rin1[i] = 1'b0;   // initializing the input array
        rin2[i] = 1'b0;
    end
    #3;
    for (i = 0; i < 10; i = i + 1) begin
        rin1[i] = 1'b1;   // initializing the input array
    end
  end
  //--------------------------------------------------------------------
  
  //--------------------------------------------------------------------
  // clock generation process (least significant bit is a clock signal; rest are 0)
  initial begin
    rin2[0] = 0;
    forever #5 rin2[0] = ~rin2[0];
  end
  //--------------------------------------------------------------------
  
  //------------------- for initilizing the feedback wire ------------- 
  genvar k;                                     
  for (k = 0; k < 10; k = k + 1) begin
    assign input_after_and[k] = final_sum[k] & rin1[k];
  end
  //--------------------------------------------------------------------
  
  counter counter_inst (   // here i used the same variable names of input and target module
  .rin1(input_after_and), 
  .rin2(rin2), 
  .final_sum(final_sum)
  );
//     temp temp_inst (   // here i used the same variable names of input and target module
//   .rin1(input_after_and), 
//   .rin2(rin2), 
//   .final_sum(final_sum)
//   );
    
  //--------------------------------------- TEST BENCH -----------------------------
  initial begin
      $monitor("Time = %0t | input = %b | clk = %b | final sum = %b", $time, input_after_and, rin2, final_sum);
      #100;
      $finish;
  end 
  //--------------------------------------------------------------------
 
endmodule // half_adder_tb

module half_adder (in_1, in_2, sum, carry);
  input  in_1;
  input  in_2;
  output sum;
  output carry;
 
  assign  sum   = in_1 ^ in_2;  // bitwise xor
  assign  carry = in_1 & in_2;  // bitwise and
 
endmodule // half_adder


module full_adder (in_1, in_2, in_3, sum, carry);
  input  in_1;
  input  in_2;
  input  in_3;
  output sum;
  output carry;
  wire wsum1;
  wire wcarry1;
  wire wcarry2;
 
    half_adder half_adder_inst1
    (
     .in_1 (in_1),
     .in_2 (in_2),
     .sum (wsum1),
     .carry (wcarry1)
     );
     
    half_adder half_adder_inst2
    (
     .in_1 (in_3),
     .in_2 (wsum1),
     .sum (sum),
     .carry (wcarry2)
     );
    
  assign  carry = wcarry1 | wcarry2;
  
endmodule // full_adder



// old verilog does not allow passing the array // this seems like a different representation of array
module counter (input [0:9]rin1, input [0:9]rin2, output [0:9]final_sum);
    wire [0:9]temp_sum;
    wire [0:9]final_carry;
    half_adder half_adder_inst
      (
     .in_1  (rin1[0]),
     .in_2  (rin2[0]),
     .sum   (temp_sum[0]),
     .carry (final_carry[0])
     );

  genvar j;
  generate
    for (j = 1; j < 10; j = j + 1) begin: full_adder_inst
      full_adder full_adder_inst
        (
         .in_1  (rin1[j]),
         .in_2  (rin2[j]),
         .in_3  (final_carry[j-1]),
         .sum   (temp_sum[j]),
         .carry (final_carry[j])
         );  
    end
  endgenerate
 
  assign #1 final_sum = temp_sum;   // added delay intentionally
  //assign final_sum[10]  = final_carry[9];
endmodule




// old verilog does not allow passing the array // this seems like a different representation of array
module temp (input [0:9]rin1, input [0:9]rin2, output [0:9]final_sum);
    assign #1 final_sum = ~rin1;
endmodule





