// Base class definition
class bike;
  // Enum declaration for bike brands
  typedef enum {HERO, YAMAHA, HONDA, KTM} brand;

  // Function to display enum brand using .name()
  function void display(brand br);
    $display("Brand --> %0s", br.name());
  endfunction
endclass

// Derived class from bike
class child extends bike;
  // Function to display a hardcoded enum brand using proper method
  function void display();
    brand br = YAMAHA;  // Declare and assign enum value
    $display("Brand --> %0s", br.name());  // Use .name() to get string representation
  endfunction
endclass

// Test module to instantiate and invoke methods
module test;
  bike b;
  child c = new();  // Create object of child class

  initial begin
    b = new();                         // Create object of base class
    b.display(bike::KTM);             // Call base class display with enum argument
    c.display();                      // Call overridden display in child
  end
endmodule
