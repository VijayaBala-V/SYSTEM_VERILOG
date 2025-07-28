class bikes;
  virtual function bike_brand();
    $display("Bike Brand");
  endfunction
  virtual task features();
    $display("Model and engine_capacity");
  endtask
endclass

class royal_enfield extends bikes;
  function bike_brand();
    $display("brand---->Royal Enfield");
  endfunction
  task features();
    $display("Model-->Bullet \nEngine_capacity-->349cc");
  endtask
endclass

class yamaha extends bikes;
  function bike_brand();
    $display("brand---->Yamaha");
  endfunction
  task features();
    $display("Model-->FZ \nEngine_capacity-->190cc");
  endtask
endclass


class scooter extends yamaha;
  function bike_brand();
    $display("Brand-->Yamaha");
  endfunction
  
  task features();
    $display("Model=Fascino \nEngine_capacity=125cc");
  endtask
endclass

module sample;
  initial
    begin
  bikes bike;
  royal_enfield r=new();
  yamaha y=new();
  scooter s=new();
  bike=r;
  bike.bike_brand();
  bike=y;
  bike.bike_brand;
  y=s;
  y.features();
    end
endmodule 
