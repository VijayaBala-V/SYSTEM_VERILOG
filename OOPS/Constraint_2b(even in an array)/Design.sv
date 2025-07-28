// Class to generate even, strictly increasing numbers in an array
class even;
  rand bit [5:0] arr[15];  // 6-bit elements (0 to 63), 15-element array

  // Constraint: all values must be even and strictly increasing
  constraint c {
    foreach (arr[i]) {
      arr[i] % 2 == 0;  // Ensures even numbers
      if (i > 0) {
        arr[i] > arr[i-1];  // Ensures strict monotonic increase
      }
    }
  }
endclass

// Testbench to create and display the constrained array
module sample;
  even e;

  initial begin
    e = new();
    if (!e.randomize())
      $display("Randomization failed!");
    else begin
      foreach (e.arr[i])
        $display("value of arr[%0d] = %0d", i, e.arr[i]);
    end
  end
endmodule
