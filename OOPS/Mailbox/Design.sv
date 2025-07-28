class transaction;
  rand bit [7:0] addr;
  rand bit [7:0] data;

  function void display();
    $display("Transaction: addr = %0h, data = %0h", addr, data);
  endfunction
endclass

class generator;
  transaction trans;
  mailbox gen;

  function new(mailbox gen);
    this.gen = gen;
  endfunction

  task main();
    trans = new();
    if (trans.randomize()) begin
      $display("[GEN] Sending transaction...");
      trans.display();
      gen.put(trans);
    end else begin
      $display("[GEN] Randomization failed.");
    end
  endtask
endclass

class driver;
  mailbox gen;

  function new(mailbox gen);
    this.gen = gen;
  endfunction

  task main();
    transaction trans;
    gen.get(trans); // Corrected from `gen(trans)` to `gen.get(trans)`
    $display("[DRV] Received transaction...");
    trans.display();
  endtask
endclass

module testbench;
  mailbox gen = new();
  generator g;
  driver d;

  initial begin
    g = new(gen);
    d = new(gen);

    fork
      g.main();
      d.main();
    join
  end
endmodule
