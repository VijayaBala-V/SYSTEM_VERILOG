// A class that conditionally constrains data based on 'sel'
class parent;
  rand bit sel;           // Random selector bit (0 or 1)
  rand bit [4:0] data;    // 5-bit data field (range 0–31)

  // Conditional constraint based on the value of 'sel'
  constraint c {
    data == (sel ? 5 : 10);
  }
endclass

// Testbench module
module sample;
  parent p;

  initial begin
    p = new();
    repeat (5) begin
      if (p.randomize())
        $display("sel = %0d, data = %0d", p.sel, p.data);
      else
        $display("Randomization failed!");
    end
  end
endmodule
