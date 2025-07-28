class sample;
  protected int i;  // Changed from 'local' to 'protected' so child can access
  int j;

  // Function to access 'i' from within sample
  function void access(int i);
    this.i = i;
    $display("Inside sample: i = %0d", this.i);
  endfunction
endclass

// Declared outside of sample for clarity
class child extends sample;
  function void display(int i);
    this.i = i;  // Now legal because 'i' is protected, not local
    $display("Inside child: i = %0d", this.i);
  endfunction
endclass

module test;
  initial begin
    sample s = new();
    child c = new();

    s.j = 10;
    s.access(20);       // Sets sample::i to 20
    c.display(30);      // Sets child (actually sample base)::i to 30
    $display("s.j = %0d", s.j);
  end
endmodule
