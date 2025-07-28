class parent;
  integer i=1;
  virtual function integer init();
    init=i;
  endfunction
endclass

class child extends parent;
  integer i=2;
   function integer init();
    init=-i;
  endfunction
endclass

module example;
  int j;
  initial
    begin
      child c=new();
      parent p=c;
      j=p.init();
      $display("value of j=%0d",j);
    end
  
  initial 
    begin
      $dumpfile("tb.vcd");
      $dumpvars();
  end
endmodule
