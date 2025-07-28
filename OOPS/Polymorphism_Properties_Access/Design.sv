// Base class definition
class parent;
  int a;  // Data member 'a'
  int b;  // Data member 'b'

  // Virtual function to be overridden by derived class
  virtual function void display();
    $display("Base Class a=%0d b=%0d", a, b);
  endfunction
endclass

// Derived class extending the parent class
class child extends parent;

  // Overriding the base class 'display' function
  function void display();
    $display("Child Class a=%0d b=%0d", a, b);
  endfunction
endclass

// Test module to demonstrate polymorphism
module sample;
  initial begin
    child c = new();   // Create an object of child class
    parent p;          // Declare a handle of type parent

    if (!$cast(p, c)) begin
      $display("Casting failed!");
      $finish;
    end

    // Assign values using parent handle
    p.a = 10;
    p.b = 20;

    // Overwrite values using child handle
    c.a = 30;
    c.b = 40;

    // Call virtual display function via parent handle
    // Due to dynamic dispatch, child's display() will be called
    p.display();  // Expected output: Child Class a=30 b=40

    $finish;
  end
endmodule

