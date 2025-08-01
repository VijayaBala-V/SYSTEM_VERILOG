module testbench;

reg clk=0;
reg rst=0;
reg tx_enable=0;
reg mosi;
reg ss;
reg sclk;

always #5 clk=~clk;

initial 
begin
rst=1;
repeat(5)@(posedge clk);
rst=0;
end

initial
begin
tx_enable=0;
repeat(5)@(posedge clk);
tx_enable=1;
end

fsm_spi dut(clk,rst,tx_enable,mosi,ss,sclk);
endmodule
