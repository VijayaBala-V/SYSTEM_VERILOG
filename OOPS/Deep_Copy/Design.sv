class class1;
  int addr;
endclass

class class2;
  bit [3:0]a;
  class1 c;
  function deep_copy(class1 inst);
    c=new inst;
  endfunction
endclass

module sample;
  class2 t1,t2;
  initial
    begin
  t1=new();
  t1.c=new();
  t1.a=5;
  t1.c.addr='hf2;
  t2=new t1;
  
  t2.deep_copy(t1.c);
  $display("value of t1.a=%0d t1.c.addr=%0h",t1.a,t1.c.addr);
  $display("value of t2.a=%0d t2.c.addr=%0h",t2.a,t2.c.addr);
  
  t2.a=7;
  t2.c.addr='hff;
  $display("value of t1.a=%0d t1.c.addr=%0h",t1.a,t1.c.addr);
  $display("value of t2.a=%0d t2.c.addr=%0h",t2.a,t2.c.addr);
    end
endmodule
  
