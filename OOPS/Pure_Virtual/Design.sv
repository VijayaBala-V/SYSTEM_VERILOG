virtual class parent;
  integer i;
  pure virtual function void init(int a); 
endclass

class child extends parent;
  function void init(int a);
    i=-a;
    $display("value of i=%0d",i);
  endfunction
endclass

module sample;
  initial
    begin
      child c=new();
      c.init(5);
    end
endmodule
