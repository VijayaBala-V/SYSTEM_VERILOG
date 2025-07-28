class class1;
  int addr;
endclass

class class2;
  bit [3:0]a;
  class1 c;
endclass

module sample;
  class2 t1,t2;
  initial 
    begin
      t1=new();
      t1.c=new();
      
      t1.a=6;
      t1.c.addr='hff;
      
      t2=new t1;
      $display("value of t1.a=%0d t1.c.addr=%0d",t1.a,t1.c.addr);
      $display("value of t2.a=%0d t2.c.addr=%0d",t2.a,t2.c.addr);
      
      t2.a=2;
      t2.c.addr='hf1;
      $display("value of t1.a=%0d t1.c.addr=%0d",t1.a,t1.c.addr);
      $display("value of t2.a=%0d t2.c.addr=%0d",t2.a,t2.c.addr);
      
    end
endmodule
