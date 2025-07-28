// Class that assigns 'data' based on value of 'sel'
class parent;
  rand bit [1:0] sel;     // 2-bit selector (values: 0–3)
  rand bit [4:0] data;    // 5-bit data field

  // Constraint: assign 'data' based on 'sel'
  constraint c {
    if (sel == 0)
      data == 5;
    else if (sel == 1)
      data == 10;
    else
      data == 13;
  }
  
  /*
  constraint c {
  case (sel)
    0: data == 5;
    1: data == 10;
    default: data == 13;
  endcase
}

  */
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
