// Base class representing a simple data structure
class parent;
  bit [3:0] addr;            // 4-bit address
  const int data = 8;        // Constant data value

  // Method to display address and data
  function void display();
    $display("Address = %0d, Data = %0d", addr, data);
  endfunction
endclass

// Test module to create and display a parent object
module sample;
  parent p;

  initial begin
    p = new();                        // Create an instance of the class
    p.addr = $urandom_range(0, 15);   // Assign a 4-bit random address
    p.display();                      // Display the field values
  end
endmodule
