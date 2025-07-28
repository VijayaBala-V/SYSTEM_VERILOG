// Class definition for 'bike'
class bike;
  static string brand;   // Static class variable for brand
  static string model;   // Static class variable for model

  // Static function to display model information
  static function void display(string model);
    bike::model = model;  // Assign input to the class static variable
    $display("Model --> %0s", bike::model);
  endfunction
endclass

// Test module to demonstrate static member usage
module example;
  initial begin
    // Accessing and assigning static member without object
    bike::brand = "Yamaha";
    $display("Brand --> %0s", bike::brand);

    // Calling static function and updating model
    bike::display("FZ");
  end
endmodule
