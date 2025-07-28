class packet;
  rand bit [3:0] start_addr;
  rand bit [3:0] end_addr;

  // Constraint using a static function
  constraint c { start_addr == s_addr(end_addr); }

  // Static and pure function for use inside constraint
  static function bit [3:0] s_addr(bit [3:0] x);
    if (x < 4)
      return 0;
    else
      return x - 4;
  endfunction
endclass

module sample;
  initial begin
    packet p = new();
    repeat (3) begin
      p.randomize();
      $display("start_addr = %0d, end_addr = %0d", p.start_addr, p.end_addr);
    end
  end
endmodule
