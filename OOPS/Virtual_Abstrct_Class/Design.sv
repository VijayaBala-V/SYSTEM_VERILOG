virtual class bikes;
  virtual function brand();
  endfunction
  virtual task feature();
    string model;
    int engine_capacity;
  endtask
endclass

class royal_enfield extends bikes;
  function brand();
    $display("Brand--->Royal Enfield");
  endfunction
  
  task feature();
    $display("model=Bullet \nengine_capacity=390cc");
  endtask
endclass

class yamaha extends bikes;
  function brand();
    $display("Brand--->Yamaha");
  endfunction
  
  task feature();
    $display("Model=FZ \nengine_capacity=350cc");
  endtask
endclass

module sample;
  initial 
    begin
      royal_enfield r=new();
      yamaha y=new();
      r.brand();
      r.feature();
      y.brand();
      y.feature();
    end
endmodule
