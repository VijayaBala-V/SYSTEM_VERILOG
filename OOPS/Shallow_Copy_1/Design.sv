//it copies only methods and vars not objects
class sample;
  bit [3:0]a;
endclass

module sample;
  sample t1,t2;
  initial 
    begin
  t1=new();
  t1.a=8;
  t2=new t1;
      $display("t1.a=%0d",t1.a);
  $display("t2.a=%0d",t2.a);
  
  t2.a=2;
      $display("t1.a=%0d",t1.a);
  $display("t2.a=%0d",t2.a);
    end
endmodule
  
