class parent;
  int add;
  int sub;
  
  function calculation(int a,b);
    add=a+b;
    sub=a-b;
  endfunction
endclass

class child extends parent;
  int mul;
  function calculation(int a,b);
    super.calculation(a,b);
    mul=a*b;
  endfunction
endclass

module sample;
  initial 
    begin
      child c;
      c=new();
      c.calculation(6,4);
      $display("addition=%0d subraction=%0d multiplication=%0d",c.add,c.sub,c.mul);
    end
endmodule
