// Class where 'data' is conditionally constrained based on 'sel'
class parent;
  rand bit [1:0] sel;     // 2-bit selector: values from 0 to 3
  rand bit [4:0] data;    // 5-bit data: values from 0 to 31

  // Constraint using implication (->) to bind 'data' based on 'sel'
  constraint c {
    (sel == 0) -> data == 5;
    (sel == 1) -> data == 10;
    (sel == 2) -> data == 15;
    (sel == 3) -> data == 20;
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
