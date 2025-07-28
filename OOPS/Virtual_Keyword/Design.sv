class packet;
  integer i=1;
  //function integer init();
   virtual function integer init();
    init=i;
  endfunction
endclass

class child_packet extends packet;
  integer i=2;
  function integer init();
    init=-i;
  endfunction
endclass

module sample;
  int j;
  initial 
    begin
      child_packet c=new();
      packet p=c;//upcasting
      //child_packet c=p;//downcasting
      
      $display("value of i=%0d",p.i);
      
      j=p.init();
      $display("value of j=%0d",j);
      
    end
endmodule
