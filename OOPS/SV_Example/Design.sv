//hello world program

/*module hello;
  initial
    begin
  $display("hello world");
    end
endmodule

// Design: JK Flip-Flop
module jk(input j, input k, input clk, output reg q);
  always @(posedge clk) begin
    case ({j, k})
      2'b00: q <= q;         // No change
      2'b01: q <= 0;         // Reset
      2'b10: q <= 1;         // Set
      2'b11: q <= ~q;        // Toggle
    endcase
  end
endmodule

// Testbench
module tb;
  reg j, k, clk;
  wire q;

  // Instantiate design
  jk dut(j, k, clk, q);

  // Clock generation: 10 time units period
  initial clk = 0;
  always #5 clk = ~clk;

  // Stimulus
  initial begin
    j = 0; k = 0;
    #10 j = 0; k = 1;
    #10 j = 1; k = 0;
    #10 j = 1; k = 1;
    #10 j = 0; k = 0;
    #10 j = 1; k = 1;
    #10 j = 0; k = 1;
    #10 j = 1; k = 0;
    #10 j = 1; k = 1;
    #10;
    $finish;
  end

  // Monitor and waveform
  initial begin
    $monitor("Time=%0t | j=%0b k=%0b q=%0b", $time, j, k, q);
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end
endmodule*/

// D Flip-Flop Design
module dff(input d, clk, rstn, output reg q);
  always @(posedge clk or negedge rstn)
    if (!rstn)
      q <= 0;
    else
      q <= d;
endmodule

// Testbench
module tb;
  reg d, clk, rstn;
  wire q;
  reg [2:0] delay;

  // Instantiate the DFF
  dff dut(.d(d), .clk(clk), .rstn(rstn), .q(q));

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  // Stimulus
  initial begin
    $monitor("Time=%0t | d=%0b q=%0b", $time, d, q);

    d <= 0;
    rstn <= 0;
    #15 d <= 1;
    #10 rstn <= 1;

    for (int i = 0; i < 5; i = i + 1) begin
      delay = $urandom_range(1, 10);  // Safe delay range
      #(delay) d <= i;
    end

    #50 $finish;
  end

  // Dump VCD
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end
endmodule
