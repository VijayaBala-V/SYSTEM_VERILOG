// Class with data constrained to 10 to 30
class packet;
  rand bit[5:0] data;  // 6-bit is safe for up to 63

  // Constraint: value must be between 10 and 30
  constraint c {
    data >= 10;
    data <= 30;
  }
endclass

// Testbench to generate and display values
module sample;
  packet p;

  initial begin
    p = new();
    repeat (5) begin
      if (p.randomize())
        $display("Randomized data = %0d", p.data);
      else
        $display("Randomization failed!");
    end
  end
endmodule
