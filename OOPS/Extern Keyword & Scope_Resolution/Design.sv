// Class definition for 'bike'
class bike;
  string model;              // Model name of the bike
  int engine_capacity;       // Engine capacity in cc

  // External function and task declarations (defined outside the class body)
  extern function void display();                      
  extern task features(string model, int engine_capacity); 
endclass

// Definition of the 'display' function outside the class
function void bike::display();
  $display("Brand --> Yamaha");
endfunction

// Definition of the 'features' task outside the class
task bike::features(string model, int engine_capacity);
  // Assigning input arguments to class properties using 'this' keyword
  this.model = model;
  this.engine_capacity = engine_capacity;

  // Displaying model and engine capacity
  $display("Model = %0s  Engine Capacity = %0d cc", model, engine_capacity);
endtask

// Top-level test module
module sample;
  bike b;  // Object handle of type 'bike'

  initial begin
    b = new();                      // Create a new instance of bike
    b.display(); 
    // Call display method to print brand info
    b.features("FZ", 349);          // Call features method with model and capacity
  end
endmodule
