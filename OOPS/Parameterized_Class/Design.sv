// Parameterized class definition for 'packet'
class packet #(parameter int WIDTH = 4);
  // Data member with width defined by parameter
  bit [WIDTH-1:0] data;

  // Method to display the contents of 'data'
  function void display();
    $display("Data (WIDTH=%0d) = %0h", WIDTH, data);
  endfunction
endclass

// Testbench module to demonstrate parameterized class instantiations
module test;
  // Instantiate packets with different data widths
  packet p4;           // Uses default WIDTH = 4
  packet #(8) p8;      // WIDTH = 8
  packet #(16) p16;    // WIDTH = 16

  initial begin
    // Allocate memory for each object
    p4  = new();
    p8  = new();
    p16 = new();

    // Assign values and display
    p4.data  = 15;     // 4-bit max is 15 (0xF)
    p4.display();

    p8.data  = 255;    // 8-bit max is 255 (0xFF)
    p8.display();

    p16.data = 256;    // 16-bit allows 256 (0x0100)
    p16.display();
  end
endmodule
