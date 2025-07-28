// Class to generate 15 unique even numbers in a 6-bit array
class data;
  rand bit [5:0] arr[15];  // 6-bit values: range 0–63

  // Constraint: All elements must be even and unique
  constraint c {
    foreach (arr[i]) {
      arr[i] % 2 == 0;  // Enforce even numbers

      // Uniqueness constraint
      foreach (arr[j]) {
        if (i != j)
          arr[i] != arr[j];  // Enforce uniqueness
      }
    }
  }
endclass

// Testbench to generate and display the constrained array
module sample;
  data d;

  initial begin
    d = new();

    if (!d.randomize())
      $display("Randomization failed!");
    else begin
      foreach (d.arr[i])
        $display("value of arr[%0d] = %0d", i, d.arr[i]);
    end
  end
endmodule
