// uart_tb.v
module uart_tb;

  reg clk = 0, rst = 0;
  reg [7:0] dintx = 0;
  reg newd = 0;
  wire tx, donetx, donerx;
  wire [7:0] doutrx;
  wire rx;

  // Loopback connection
  assign rx = tx;

  uart_top #(1000000, 9600) dut (
    .clk(clk), .rst(rst), .rx(rx),
    .dintx(dintx), .newd(newd),
    .tx(tx), .donetx(donetx),
    .donerx(donerx), .doutrx(doutrx)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    $display("Start UART simulation...");
    rst = 1;
    #100;
    rst = 0;

    for (int i = 0; i < 5; i++) begin
      dintx = $urandom_range(0, 255);
      newd = 1;
      #10;
      newd = 0;
      wait(donetx);
      wait(donerx);

      $display("TX Sent: %h | RX Received: %h", dintx, doutrx);
      #1000;
    end

    $finish;
  end

endmodule
