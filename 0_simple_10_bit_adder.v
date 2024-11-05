module top_module;         // top module is the one that contains "initial begin"
 
  reg  rin1[0:9];           // input array 1
  reg  rin2[0:9];           // input array 2
  wire final_carry[0:9];
  wire final_sum  [0:10];
   
  integer i; 
  initial begin
    for (i = 0; i < 10; i = i + 1) begin
        rin1[i] = 1'b1;   // initializing the input array
    end
    for (i = 1; i < 10; i = i + 1) begin
        rin2[i] = 1'b0;   // initializing the input array
    end
    rin2[0] = 1'b1;
  end
  
  half_adder half_adder_inst
      (
     .in_1  (rin1[0]),
     .in_2  (rin2[0]),
     .sum   (final_sum[0]),
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
         .sum   (final_sum[j]),
         .carry (final_carry[j])
         );  
    end
  endgenerate
  
  assign final_sum[10]  = final_carry[9];
 
  initial begin
      $display("unfortunately, verilog does not provide the capability of user defined inputs\n");
      $display("Sample Input 1:");
      #10;
      for (i = 0; i < 10; i = i + 1) begin
        $write("%b ", rin1[i]);
      end
      $write("\n\n");
      
      $display("Sample Input 2:");
      for (i = 0; i < 10; i = i + 1) begin
        $write("%b ", rin2[i]);
      end
      $write("\n\n");
      
      $display("Output:");
      for (i = 0; i < 11; i = i + 1) begin
        $write("%b ", final_sum[i]);
      end
      $write("\n");
      
    //   for (i = 0; i < 10; i = i + 1) begin
    //     $write("%b ", final_carry[i]);
    //   end
      $write("\n");
  end 
 
endmodule // half_adder_tb




module half_adder (in_1, in_2, sum, carry);
  input  in_1;
  input  in_2;
  output sum;
  output carry;
 
  assign sum   = in_1 ^ in_2;  // bitwise xor
  assign carry = in_1 & in_2;  // bitwise and
 
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
    
  assign carry = wcarry1 | wcarry2;
  
endmodule // full_adder









