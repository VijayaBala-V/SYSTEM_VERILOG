// Base class with constant data member initialized via constructor
class parent;
  bit [3:0] addr;
  const int data;

  // Constructor with initialization list for 'const' variable
  function new(bit [3:0] addr, int data);
    this.addr = addr;
    this.data = data; //  Legal here if done via initialization list (see note below)
  endfunction

  /*
  function new(bit [3:0] addr, int data);
  this.addr = addr;
  super.new();
  const'(this.data = data); // or use a construct-specific mechanism if required
endfunction

  */
  // Display method
  function void display();
    $display("addr = %0d  data = %0d", addr, data);
  endfunction
endclass

// Testbench module
module sample;
  parent p;

  initial begin
    p = new(10, 8);  // Create object with addr = 10, data = 8
    p.display();
  end
endmodule
