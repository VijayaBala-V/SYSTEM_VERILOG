typedef class datas;
  
  // Data holder class

class datas;
  int data = $urandom; // Random data generated at construction
endclass

// Parent class that contains an address and a reference to 'datas'
class parent;
  bit [3:0] addr;
  datas d = new();     // Create instance of 'datas'

  // Display method
  function void display();
    $display("addr = %0d, data = %0d", addr, d.data);
  endfunction
endclass

// Testbench module
module sample;
  parent p;

  initial begin
    p = new();       // Create parent object
    p.addr = 9;      // Assign a 4-bit address
    p.display();     // Display contents
  end
endmodule
