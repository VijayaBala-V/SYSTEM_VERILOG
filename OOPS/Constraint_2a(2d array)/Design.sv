// Class with a 2D static array and constraint on its elements
class parent;
  rand int arr[5][3];  // 2D array: 5 rows, 3 columns

  // Constraint: Each element arr[i][j] = i * j
  constraint c {
    foreach (arr[i, j]) {
      arr[i][j] == i * j;
    }
  }
endclass

// Testbench module to create, randomize, and display the array
module sample;
  parent p;

  initial begin
    p = new();

    if (!p.randomize())
      $display("Randomization failed!");
    else begin
      foreach (p.arr[i, j]) begin
        $display("arr[%0d][%0d] = %0d", i, j, p.arr[i][j]);
      end
    end
  end
endmodule
