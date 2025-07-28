// Generic stack-like class 'packet' with parameterized data type T
class packet #(parameter type T = int);
  T item[50];  // Array to hold up to 50 items of type T
  int i = 0;   // Stack pointer/index

  // Push function to add an item to the stack
  function void push(input T val);
    if (i < 50) begin
      item[i] = val;
      $display("Pushed into item[%0d] = %s", i, format(val));
      i++;
    end else begin
      $display("Container Overflow! Cannot push %s", format(val));
    end
  endfunction

  // Pop function to remove and return an item from the stack
  function T pop();
    T pop_val;
    if (i > 0) begin
      i--;
      pop_val = item[i];
      $display("Popped value = %s", format(pop_val));
      return pop_val;
    end else begin
      $display("Container Underflow! Cannot pop");
      return '0;  // Return default value of type T
    end
  endfunction

  // Helper function to convert value to displayable string (handles real and non-real types)
protected function string format(T val);
  string type_name = $typename(T);
  case (type_name)
    "real":    return $sformatf("%1.2f", val);
    default:   return $sformatf("%0d", val);
  endcase
endfunction
endclass


// Testbench module
module sample;
  // Instantiate packets with different types
  packet p1;                   // Default type = int
  packet #(bit[2:0]) p2;       // 3-bit unsigned
  packet #(real) p3;           // Real number

  initial begin
    // Object construction
    p1 = new();
    p2 = new();
    p3 = new();

    // Push random values
    p1.push($random);
    p2.push($random);
    p3.push($urandom_range(0, 1000) * 1.0);  // Generate random real

    // Pop and display returned values
    p1.pop();
    p2.pop();
    p3.pop();
  end
endmodule
