//====================== Interface ======================
interface intf(input logic clk, rst);
  logic [3:0] a, b;
  logic [3:0] c;

  // Clocking block for testbench
  clocking cb @(posedge clk);
    default input #1 output #2;
    output a, b;      // TB drives 'a' and 'b'
    input c;          // TB samples 'c'
  endclocking

  // Modports
  modport tb(clocking cb, input clk, rst);
  modport rtl(input clk, rst, a, b, output c);
endinterface

//====================== RTL Stub =======================
module design_rtl(intf.rtl inf);
  // Simple example logic
  always_ff @(posedge inf.clk or posedge inf.rst) begin
    if (inf.rst)
      inf.c <= 0;
    else
      inf.c <= inf.a + inf.b;
  end
endmodule

//====================== Top-level Testbench ======================
module top;
  bit clk;
  bit rst;

  // Clock generation
  always #5 clk = ~clk;

  // Reset logic
  initial begin
    clk = 0;
    rst = 1;
    #10 rst = 0;
  end

  // Interface instantiation
  intf _if(clk, rst);

  // DUT instantiation
  design_rtl dut(_if);

  // Test logic
  initial begin
    // Wait for reset deassertion
    @(negedge rst);
    repeat (5) begin
      @(_if.tb.cb);  // Wait for posedge clk
      _if.tb.cb.a <= $urandom_range(0, 15);
      _if.tb.cb.b <= $urandom_range(0, 15);
      @(_if.tb.cb);  // Next cycle to sample output
      $display("Time=%0t : a=%0d, b=%0d, c=%0d", $time, _if.tb.cb.a, _if.tb.cb.b, _if.tb.cb.c);
    end
    $finish;
  end
endmodule
