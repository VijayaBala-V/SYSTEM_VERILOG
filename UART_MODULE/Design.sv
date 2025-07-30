// uart_top.v
module uart_top
#(
  parameter clk_freq = 1000000,
  parameter baud_rate = 9600
)
(
  input clk, rst, 
  input rx,
  input [7:0] dintx,
  input newd,
  output tx, 
  output [7:0] doutrx,
  output donetx,
  output donerx
);

  uarttx #(clk_freq, baud_rate) utx (
    .clk(clk), .rst(rst), .newd(newd), .tx_data(dintx), .tx(tx), .donetx(donetx)
  );

  uartrx #(clk_freq, baud_rate) rtx (
    .clk(clk), .rst(rst), .rx(rx), .donerx(donerx), .rx_data(doutrx)
  );

endmodule
// uarttx.v
module uarttx
#(
  parameter clk_freq = 1000000,
  parameter baud_rate = 9600
)
(
  input clk, rst,
  input newd,
  input [7:0] tx_data,
  output reg tx = 1'b1,
  output reg donetx = 0
);

  localparam clkcount = clk_freq / baud_rate;
  integer clk_counter = 0;
  integer bit_index = 0;

  reg [9:0] tx_buffer = 10'b1111111111; // Start + data + stop
  reg sending = 0;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      clk_counter <= 0;
      bit_index <= 0;
      tx <= 1'b1;
      donetx <= 0;
      sending <= 0;
    end else begin
      if (newd && !sending) begin
        tx_buffer <= {1'b1, tx_data, 1'b0}; // {stop, data[7:0], start}
        sending <= 1;
        donetx <= 0;
        bit_index <= 0;
        clk_counter <= 0;
      end else if (sending) begin
        clk_counter <= clk_counter + 1;
        if (clk_counter >= clkcount) begin
          clk_counter <= 0;
          tx <= tx_buffer[bit_index];
          bit_index <= bit_index + 1;
          if (bit_index == 10) begin
            sending <= 0;
            donetx <= 1;
            tx <= 1;
          end
        end
      end
    end
  end

endmodule
// uartrx.v
module uartrx
#(
  parameter clk_freq = 1000000,
  parameter baud_rate = 9600
)
(
  input clk, rst,
  input rx,
  output reg donerx = 0,
  output reg [7:0] rx_data = 0
);

  localparam clkcount = clk_freq / baud_rate;
  integer clk_counter = 0;
  integer bit_index = 0;

  reg [7:0] buffer = 0;
  reg receiving = 0;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      clk_counter <= 0;
      bit_index <= 0;
      receiving <= 0;
      donerx <= 0;
      rx_data <= 0;
    end else begin
      if (!receiving && rx == 0) begin // Start bit
        receiving <= 1;
        clk_counter <= clkcount / 2; // Sample mid-bit
        bit_index <= 0;
        donerx <= 0;
      end else if (receiving) begin
        clk_counter <= clk_counter + 1;
        if (clk_counter >= clkcount) begin
          clk_counter <= 0;
          buffer[bit_index] <= rx;
          bit_index <= bit_index + 1;
          if (bit_index == 8) begin
            receiving <= 0;
            rx_data <= buffer;
            donerx <= 1;
          end
        end
      end
    end
  end

endmodule
