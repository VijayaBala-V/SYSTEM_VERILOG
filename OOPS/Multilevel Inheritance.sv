class parent;
  int add;
  function add_fun(int a,b);
    add=a+b;
  endfunction
endclass

class child1 extends parent;
  int sub;
  function sub_fun(int a,b);
    sub=a-b;
  endfunction
endclass

class child2 extends child1;
  int mul;
  function mul_fun(int a,b);
    mul=a*b;
  endfunction
endclass
  



module sample;
  initial 
    begin
      child2 c;
      c=new();
      
      c.add_fun(3,2);
      c.sub_fun(5,1);
      c.mul_fun(3,3);
      
      $display("addition=%0d  subraction=%0d  multiplication=%0d",c.add,c.sub,c.mul);
    end
endmodule
