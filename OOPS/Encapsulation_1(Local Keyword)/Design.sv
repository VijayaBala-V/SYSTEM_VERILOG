class sample;
   local int i;
  int j;
  //local access using function
  
  function void access(int i);
    this.i=i;
    $display("value of s.i=%0d",i);
  endfunction
  
 /* //local access is not working in subclass
  
  class child extends sample;
    function void display(int i);
      this.i=i;
      $display("value of s.i=%0d",i);
    endfunction
  endclass*/
    
endclass

module test;
  sample s=new();
  
  initial
    begin
    //  child c=new();
      
    s.j=10;
      s.access(20);
      //c.display(30);
      $display("value of s.j=%0d",s.j);
    end
endmodule
      
