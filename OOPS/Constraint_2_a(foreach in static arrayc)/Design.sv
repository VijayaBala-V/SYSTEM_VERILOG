// Class with statically-sized array (size fixed at declaration)
class static_arr;
  rand int arr[8];  // Static array of 8 integers

  // Constraint: each element arr[i] equals its index i
  constraint c {
    foreach (arr[i]) {
      arr[i] == i;
    }
  }
endclass

// Class with dynamically-sized array
class dynamic_arr;
  rand int arr[];  // Dynamic array (size set via constraint)

  // Constraint: array must have 5 elements
  constraint s {
    arr.size() == 5;
  }

  // Constraint: each element arr[i] equals i*i
  constraint c {
    foreach (arr[i]) {
      arr[i] == i * i;
    }
  }
endclass

// Testbench module
module test;
  static_arr p;
  dynamic_arr d;

  initial begin
    p = new();
    d = new();

    // Randomize both objects
    if (!p.randomize())
      $display("Static array randomization failed!");
    if (!d.randomize())
      $display("Dynamic array randomization failed!");

    // Display values from static array
    foreach (p.arr[i])
      $display("Static: arr[%0d] = %0d", i, p.arr[i]);

    $display("--------------------");

    // Display values from dynamic array
    foreach (d.arr[i])
      $display("Dynamic: arr[%0d] = %0d", i, d.arr[i]);
  end
endmodule
