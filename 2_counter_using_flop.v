
module top_module;         // top module is the one that contains "initial begin"
 
  wire [0:9]rin1; reg [0:9]rin2;   reg [0:9]reset;   // input arrays
  wire [0:9]final_carry; wire [0:9]final_sum;        // sum and carry
  reg clk;                                      // clock signal
  
  //--------------------------------------------------------------------
  integer i;
  initial begin
    for (i = 0; i < 10; i = i + 1) begin
        rin2[i] = 1'b0;    // initializing the input array
        reset[i]  = 1'b1;  // it will initialize rin1 using d flip flop
    end
    rin2[0] = 1'b1;
    #8;
    for (i = 0; i < 10; i = i + 1) begin
        reset[i]  = 1'b0;
    end
  end
  //--------------------------------------------------------------------
  
  //--------------------------------------------------------------------
  // clock generation process (least significant bit is a clock signal; rest are 0)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  //--------------------------------------------------------------------
  
  //------------------- for initilizing the feedback wire ------------- 
  genvar k;                                     
  for (k = 0; k < 10; k = k + 1) begin
    dflip dflip_inst (   // here i used the same variable names of input and target module
      .d(final_sum[k]), 
      .reset(reset[k]), 
      .clk(clk),
      .q(rin1[k])
    );
  end
  //--------------------------------------------------------------------
  
  counter counter_inst (   // here i used the same variable names of input and target module
  .rin1(rin1), 
  .rin2(rin2), 
  .final_sum(final_sum)
  );
    
  //--------------------------------------- TEST BENCH -----------------------------
  initial begin
      $monitor("Time = %0t | input = %b | clk = %b | final sum = %b", $time, rin1, clk, final_sum);
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
 
  assign final_sum = temp_sum;   // added delay intentionally
endmodule


//--------------------------- D FLIP FLOP -----------------------------------------
module dflip (
    input d,
    input reset,
    input clk,
    output wire q
);  
    reg qb; // Intermediate reg to hold the value

    always @ (posedge clk) begin
        if (reset) 
            qb <= 0;
        else 
            qb <= d;
    end

    assign q = qb; // Drive the wire output with qb
endmodule







