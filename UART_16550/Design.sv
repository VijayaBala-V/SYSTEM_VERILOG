/////////////// UART TX

module uart_tx_top(
input clk, rst, baud_pulse, pen, thre, stb, sticky_parity, eps, set_break,
input [7:0] din,
input [1:0] wls,
output reg pop, sreg_empty,tx
);
  
  
typedef enum logic [1:0] {idle = 0, start = 1 , send = 2 , parity = 3} state_type;
state_type state = idle;   
    
 reg [7:0] shft_reg;
 reg tx_data;
 reg d_parity;
 reg [2:0] bitcnt = 0;
 reg [4:0] count = 5'd15;
 reg parity_out;
 
 
 always@(posedge clk, posedge rst)
 begin
     if(rst)
       begin
       state  <= idle;
       count  <= 5'd15;
       bitcnt <= 0;
       ///////////////
       shft_reg   <= 8'bxxxxxxxx;
       pop        <= 1'b0;
       sreg_empty <= 1'b0;
       tx_data    <= 1'b1; //idle value
       
       end
     else if(baud_pulse)
        begin
           case(state)
           ////////////// idle state
             idle: 
              begin
                if(thre == 1'b0) ///csr.lsr.thre
                begin 
                    if(count != 0)
                      begin
                      count <= count - 1;
                      state <= idle;
                      end
                    else
                      begin
                      count <= 5'd15;
                      state <= start;
                      bitcnt  <= {1'b1,wls};
                      
                      /////////////////////////
                      
                         pop         <= 1'b1;  ///read tx fifo
                         shft_reg    <= din;   /// store fifo data in shift reg
                         sreg_empty  <= 1'b0;
                                              /////////////// calculate parity
 
                         
                         
                        /////////////////////////////////
                                              
                         tx_data <= 1'b0; ///start bit 
                      end
                 end
              end
             
             /////////////start state
             start: 
               begin
                       
                      
            
                        
                        
                     if( count != 0)
                      begin
                      count <= count - 1;
                      state <= start;
                      end
                    else
                      begin
                      count  <= 5'd15;
                      state  <= send;
                      /////////////////////////////
                         case(wls)
                         2'b00: d_parity <= ^shft_reg[4:0]; /// odd parity
                         2'b01: d_parity <= ^shft_reg[5:0];  /// even
                         2'b10: d_parity <= ^shft_reg[6:0];  /// mark
                         2'b11: d_parity <= ^shft_reg[7:0];  ///space            
                         endcase
 
                      tx_data    <= shft_reg[0]; 
                      shft_reg   <= shft_reg >> 1; 
                      ////////////////////////
                      pop        <= 1'b0;
                      end
               end
           ///////////////// send state
             send: 
               begin
                       case({sticky_parity, eps})
                        2'b00: parity_out <= ~d_parity;
                        2'b01: parity_out <= d_parity;
                        2'b10: parity_out <= 1'b1;
                        2'b11: parity_out <= 1'b0;
                        endcase
                        
                        
                     if(bitcnt != 0)
                          begin
                                if(count != 0)
                                  begin
                                  count <= count - 1;
                                  state <= send;  
                                  end
                                else
                                  begin
                                  count <= 5'd15;
                                  bitcnt <= bitcnt - 1;
                                  tx_data    <= shft_reg[0]; 
                                  shft_reg   <= shft_reg >> 1;
                                  state <= send;
                                  end
                             end
                       else
                          begin
                                ///////////////////////////
                                if(count != 0)
                                  begin
                                  count <= count - 1;
                                  state <= send;  
                                  end
                                else
                                  begin
                                   count <= 5'd15;
                                   sreg_empty <= 1'b1;
                                  
                                      if(pen == 1'b1)
                                       begin
                                         state <= parity;
                                         count <= 5'd15;
                                         tx_data <= parity_out;
                                       end  
                               ////////////////////////
                                      else
                                       begin
                                         tx_data <= 1'b1;
                                         count   <= (stb == 1'b0 )? 5'd15 :(wls == 2'b00) ? 5'd23 : 5'd31;
                                         state   <= idle;
                                       end  
                                  end
                        end/// else of bitcnt loop
               end
 
              
             parity: 
               begin
                     if(count != 0)
                      begin
                      count <= count - 1;
                      state <= parity;
                      end
                    else
                      begin
                      tx_data <= 1'b1;
                      count   <= (stb == 1'b0 )? 5'd15 :(wls == 2'b00) ? 5'd17 : 5'd31;
                      state <= idle;
                      end
               end 
               
             default: ;
            endcase   
        end
 end
 
     
////////////////////////////////////////////////////// 
always@(posedge clk, posedge rst)
begin
if(rst)
  tx <= 1'b1;
else
  tx <= tx_data & ~set_break;
end    
    
    
endmodule


/////////////////UART RX

module uart_rx_top(
input clk, rst, baud_pulse, rx, sticky_parity, eps,
input pen,
input [1:0] wls,
output reg push,
output reg pe, fe, bi,
output reg [7:0] dout
    );
 
typedef enum logic [2:0] {idle = 0, start = 1, read = 2, parity = 3, stop = 4} state_type;
state_type state = idle;
 
 
////////////////detect falling edge
reg rx_reg = 1'b1;
wire fall_edge;
 
 
always@(posedge clk)
begin
rx_reg <= rx;
end
 
assign fall_edge = rx_reg;
 
 ///////////////////////////    
 reg [2:0] bitcnt;
 reg [3:0] count = 0;
 reg pe_reg; /// parity error
  
always@(posedge clk, posedge rst)    
 begin
 if(rst)
  begin
  state <= idle;
  push  <= 1'b0;
  pe    <= 1'b0;
  fe    <= 1'b0;
  bi    <= 1'b0;
  bitcnt <= 8'h00;
  end
 else
   begin
      push  <= 1'b0;
      
      if(baud_pulse)
         begin
                   case(state)
                   
                   //////////////////////////////// idle state
                           idle : 
                           begin
                             if(!fall_edge)
                             begin
                             state <= start;
                             count <= 5'd15;
                             end
                             else
                             begin
                             state <= idle;
                             end
                           end
                       //////////////////////////////detect start   
                           
                           start:
                           begin
                           count <= count - 1;
                           
                           
                           if(count == 5'd7)
                                begin
                                     if(rx == 1'b1)
                                       begin
                                       state <= idle;
                                       count <= 5'd15;
                                       end
                                      else
                                       begin
                                       state <= start;
                                       end
                                end
                           else if (count == 0)
                                 begin
                                 state <= read;
                                 count <= 5'd15;
                                 bitcnt <= {1'b1,wls};
                                 end
                                 
                                 
                           end
                           
                           
                           ///////////////////////////read byte from rx pin
                           read: begin
                           
                               count <= count - 1;
                               
                                if(count == 5'd7)
                                begin
                                            case(wls)
                                            2'b00: dout <= {3'b000, rx, dout[4:1]}; 
                                            2'b01: dout <= {2'b00 , rx, dout[5:1]}; 
                                            2'b10: dout <= {1'b0  , rx, dout[6:1]}; 
                                            2'b11: dout <= {        rx, dout[7:1]}; 
                                            endcase
                                            
                                            state <= read;
                                end
                               else if (count == 0)
                                begin
                                        if(bitcnt == 0)
                                               begin
                                                                                                                
                                                                 case({sticky_parity, eps})
                                                                 2'b00: pe_reg <= ~^{rx,dout}; /// odd parity -> pe : no. of 1's even
                                                                 2'b01: pe_reg <= ^{rx,dout}; ///even parity
                                                                 2'b10: pe_reg <= ~rx; /// parity should be 1
                                                                 2'b00: pe_reg <= rx; /// parity should be 0
                                                                 endcase
                                                                 
                                                       if(pen == 1'b1)
                                                             begin
                                                                 state <= parity;
                                                                 count  <= 5'd15;
 
                                                             
                                                              end
                                                          else 
                                                                begin
                                                                state <= stop; 
                                                                count  <= 5'd15;
                                                                end
                                                                       
                                                         end  /// bitcnt reaches 0
                                               
                                           else
                                                      begin
                                                      bitcnt <= bitcnt - 1;
                                                      state  <= read;
                                                      count  <= 5'd15;
                                                      end  /// send rest of bits
                                 end
                           
                           end
                           
                           
                           ////////////////////////////detect parity error
                           parity: 
                           begin
                                 count <= count - 1;
                           
                           
                                         if(count == 5'd7)
                                            begin
                                             pe <= pe_reg;
                                             state <= parity;
                                            end
                                       else if (count == 0)
                                             begin
                                             state <= stop;
                                             count <= 5'd15;
                                             end
                           
                           end
                           
                           //////////////////////// detect frame error
                           stop : begin
                           
                                  count <= count - 1;
                           
                                      if(count == 5'd7)
                                            begin
                                             fe    <= ~rx;
                                             push  <= 1'b1;
                                             state <= stop;
                                            end
                                       else if (count == 0)
                                             begin
                                             state <= idle;
                                             count <= 5'd15;
                                             end
                                  end
                                  
 
                           default: ;
                           
                           
                   endcase
         end
   end
 
 end   
    
 
 
    
endmodule


////////////////// UART REG



 ////////////FCR
   typedef struct packed {
    logic  [1:0] rx_trigger;        //Receive trigger
    logic [1:0] reserved;          //reserved
    logic       dma_mode;          //DMA mode select
    logic       tx_rst;            //Transmit FIFO Reset
    logic       rx_rst;            //Receive FIFO Reset
    logic       ena;               //FIFO enabled
  } fcr_t; //FIFO Control Register
 
 ////////////// LCR
   typedef struct packed {
    logic       dlab;    
    logic       set_break;     
    logic       stick_parity;     
    logic       eps; 
    logic       pen;
    logic       stb; 
    logic [1:0] wls; 
  } lcr_t;   
  
 ////////////// LSR
   typedef struct packed {
    logic       rx_fifo_error;
    logic       temt;              //Transmitter Emtpy
    logic       thre;              //Transmitter Holding Register Empty
    logic       bi;                //Break Interrupt
    logic       fe;                //Framing Error
    logic       pe;                //Parity Error
    logic       oe;                //Overrun Error
    logic       dr;                //Data Ready
  } lsr_t; //Line Status Register
  
  ////struct to hold all registers
 typedef struct {
 fcr_t       fcr; 
 lcr_t       lcr; 
 lsr_t       lsr; 
 logic [7:0] scr; 
 } csr_t;
  
  
 typedef struct packed {
    logic [7:0] dmsb;               //Divisor Latch MSB
    logic [7:0] dlsb;               //Divisor Latch LSB
  } div_t;
 
 
 
 
module regs_uart(
input clk, rst,
input wr_i,rd_i,
input rx_fifo_empty_i,
input rx_oe, rx_pe, rx_fe, rx_bi, 
input [2:0] addr_i,
input [7:0] din_i,
 
output tx_push_o, ///add new data to TX FIFO
output rx_pop_o, ///read data from RX FIFO
 
output baud_out, /// baud pulse for both tx and rx
 
output tx_rst, rx_rst,
output [3:0] rx_fifo_threshold,
 
output reg [7:0] dout_o,
 
output csr_t csr_o,
input [7:0] rx_fifo_in
);
 
csr_t csr; ///temporary csr
////////// Register structure
/*
Total 10 registers and address bus of size 3-bit (0-7)
Seventh bit of data format registe / Divisor Latch access bit (DLAB)
DLAB = 0 -> addr :0   THR/ RHR
            addr :1   IER
DLAB = 1 -> addr :0   LSB of baud rate divisor
            addr : 1  MSB of baud rate divisor
 ---------------------------------------------------           
            addr : 2  Interrupt Identification Reg IIR (R)  + FCR(FIFO control Reg)(new) (W)
            addr : 3  Data format reg / LCR
            addr : 4  Modem control reg / MCR
            addr : 5  Serialization Status register / LSR
            addr : 6  Modem Status Reg / MSR
            addr : 7 Scratch pad reg / SPR
 ------------------------------------------------------           
*/
 
 
//-----------------------------------------------------------------------
 
///THR -> temporary buffer for stroing data to be transmitted serially
//// old uart 8250 (16550 p) :  single byte buffer
//// 16550 : 16 byte of buffer
//// once wr is high push data to tx fifo
//// if dlab = 0, wr = 1 and addr = 0 then send push signal to TX fifo
wire tx_fifo_wr;
 
assign tx_fifo_wr = wr_i & (addr_i == 3'b000) & (csr.lcr.dlab == 1'b0);
assign tx_push_o = tx_fifo_wr;  /// go to tx fifo
 
//-----------------------------------------------------------------------
 
//RHR -> Hold the data recv by the shift register serially
//// read the data and push in the RX FIFO
//// if dlab = 0, rd = 1 and addr = 0 then send pop signal to RX fifo
wire rx_fifo_rd;
 
assign rx_fifo_rd = rd_i & (addr_i == 3'b000) & (csr.lcr.dlab == 1'b0);
assign rx_pop_o = rx_fifo_rd; ///read data from rx fifo --> go to rx fifo
 
reg [7:0] rx_data;
 
always@(posedge clk)
begin
 if(rx_pop_o)
   begin
   rx_data <= rx_fifo_in;
   end
end
//----------------------------------------------------------------------
 
 
///////// Baud Generation Logic
 
//////structure for holding msb and lsb of baud counter
// typedef struct packed {
//    logic [7:0] dmsb;               //Divisor Latch MSB
//    logic [7:0] dlsb;               //Divisor Latch LSB
//  } div_t;
 
 
  div_t dl;
 
 ///////// update dlsb if wr = 1 dlab = 1 and addr = 0
   always @(posedge clk)
     begin
     if ( wr_i && addr_i == 3'b000 && csr.lcr.dlab == 1'b1)
        begin
        dl.dlsb <= din_i;
        end    
     end
     
  ///////// update dmsb if wr = 1 dlab = 1 and addr = 1
   always @(posedge clk)
     begin
     if ( wr_i && addr_i == 3'b001 && csr.lcr.dlab == 1'b1)
        begin
        dl.dmsb <= din_i;
        end    
     end 
 
 
 reg update_baud;
 reg [15:0] baud_cnt = 0;
 reg baud_pulse = 0;
  
  ///////sense update in baud values
    always @(posedge clk)
    begin
       update_baud <=  wr_i & (csr.lcr.dlab == 1'b1) & ((addr_i == 3'b000) | (addr_i == 3'b001));
    end  
 
 /////////////// baud counter
 
   always @(posedge clk, posedge rst)
   begin
    if (rst)
      baud_cnt  <= 16'h0;
    else if (update_baud || baud_cnt == 16'h0000)
      baud_cnt <= dl;
    else
      baud_cnt <= baud_cnt -1;
   end
 
  //generate baud pulse when baud count reaches zero
   always @(posedge  clk)
    begin
      baud_pulse <= |dl & ~|baud_cnt; 
    end
 
 
assign baud_out = baud_pulse; /// baud pulse for both tx and rx 
//-----------------------------------------------------------------------
 
 
/////////// FIFO Control Reg (FCR)
/// Use to Enable FIFO Mode, Set FIFO Threshold, Clear FIFO
 
// 0 -> Enable TX and RX FIFO
// 1 -> Clear RECV FIFO
// 2 -> Clear TX FIFO
// 3 -> DMA Mode Enable
// 4-5 -> Reserved
/*
 6-7 -> FIFO Threshold / trigger level for RX FIFO
00 - 1 byte
01 - 4 bytes
10 - 8 bytes
11 - 14 bytes
threshold will enable interrupt request , level falls below thre will clear interrupt
*/
 
////fifo write operation-> read data from user and update bits of fcr
 
   always @(posedge clk, posedge rst)
   begin
     if(rst)
       begin
       csr.fcr <= 8'h00;
       end 
      else if (wr_i == 1'b1 && addr_i == 3'h2)
       begin
       csr.fcr.rx_trigger <= din_i[7:6];
       csr.fcr.dma_mode   <= din_i[3];
       csr.fcr.tx_rst     <= din_i[2];
       csr.fcr.rx_rst     <= din_i[1];
       csr.fcr.ena        <= din_i[0];
       end
       else
       begin
       csr.fcr.tx_rst     <= 1'b0;
       csr.fcr.rx_rst     <= 1'b0;
       end
   end
 
 
assign tx_rst = csr.fcr.tx_rst;  ////reset tx and rx fifo --> go to tx and rx fifo
assign rx_rst = csr.fcr.rx_rst;
 
//////// based on value of rx_trigger, generate threshold count for rx fifo
 
reg [3:0] rx_fifo_th_count = 0;
 
always_comb
begin
if(csr.fcr.ena == 1'b0)
 begin
  rx_fifo_th_count = 4'd0;
 end
else
 case(csr.fcr.rx_trigger)
  2'b00: rx_fifo_th_count = 4'd1;
  2'b01: rx_fifo_th_count = 4'd4;
  2'b10: rx_fifo_th_count = 4'd8;
  2'b11: rx_fifo_th_count = 4'd14;
 endcase
end
 
 
assign rx_fifo_threshold = rx_fifo_th_count;   /// -- > go to rx fifo
//-------------------------------------------------------------------------------
 
////////////////// Line Control Register --> defines format of transmitted data
 
 
//  typedef struct packed {
//    logic       dlab;    
//    logic       set_break;     
//    logic       stick_parity;     
//    logic       eps; 
//    logic       pen;
//    logic       stb; 
//    logic [1:0] wls; 
//  } lcr_t; 
 
/////// 0000 1100
 lcr_t lcr;
 reg [7:0] lcr_temp;
 
 //////////// write new data to lcr
 always @(posedge clk, posedge rst)
   begin
     if(rst)
       begin
       csr.lcr <= 8'h00;
       end 
     else if (wr_i == 1'b1 && addr_i == 3'h3)
       begin
       csr.lcr <= din_i;
       end
   end
 
 //////// read lsr 
 wire read_lcr;
 
 assign read_lcr = ((rd_i == 1) && (addr_i == 3'h3));
 
always@(posedge clk)
 begin
  if(read_lcr)
   begin
   lcr_temp <= csr.lcr;
   end
end
 
 //////////////////////////////////////////////////////////
 
 
 
 
 
//  typedef struct packed {
//    logic       rx_fifo_error;
//    logic       temt;              //Transmitter Emtpy
//    logic       thre;              //Transmitter Holding Register Empty
//    logic       bi;                //Break Interrupt
//    logic       fe;                //Framing Error
//    logic       pe;                //Parity Error
//    logic       oe;                //Overrun Error
//    logic       dr;                //Data Ready
//  } lsr_t; //Line Status Register
  
  
 reg [7:0] LSR_temp;
////// ----- LSR -- Serialization Status register   ---> Read only register
///////////////// - 8250
///// Trans Overwrite | Recv Overrun | Break | Parity Error | Framing Error | TXE | TBE | RxRDY 
/////      0                  1          2          3               4          5     6      7
 
//////////////   -16550
/////   DR | OE | PE | FE | BI | THRE | TEMT | RXFIFOE                                                                                  
////     0 <--------------------------------------> 7 
 
//-------------------bit 0 ---------------------------------
///bit 0 shows byte is rcvd in the rcv bufer and buffer can be read.
/// fifo will reset empty flag if data is present in rxfifo
//// LSR[0] <= ~empty_flag;
//// if flag is 1 / no data -> buffer is empty and do not require read
/////  flag is 0 / some data -> buffer have data and can be read
 
//-------------------bit 1 ---------------------------------
////////// Overrun error  - Data recv from serial port is slower than it recv
////////// occurs when data is recv after fifo is full and shift reg is already filled
 
 
///// -------------------- bit 2 -----------------------------
//////// PE - Parity error 
/*
0 = No parity error has been detected,
1 = A parity error has been detected with the character at the top of the receiver FIFO.
*/
 
///// -------------------- bit 3 -----------------------------
//////// FE - Frame error 
/*
 A framing error occurs when the received character does not have a valid STOP bit. In
response to a framing error, the UART sets the FE bit and waits until the signal on the RX pin goes high.
*/
 
///// -------------------- bit 4 -----------------------------
//////// Bi - Break indicator
/*
The BI bit is set whenever the receive data input (UARTn_RXD) was held low for longer than a
full-word transmission time. A full-word transmission time is defined as the total time to transmit the START, data,
PARITY, and STOP bits. 
*/
 
///// -------------------- bit 5 -----------------------------
//////// THRE
/*
0 = Transmitter FIFO is not empty. At least one character has been written to the transmitter FIFO. The transmitter
FIFO may be written to if it is not full.
1 = Transmitter FIFO is empty. The last character in the FIFO has been transferred to the transmitter shift register
(TSR).
*/
 
///// -------------------- bit 6 -----------------------------
//////// TEMT
/*
0 = Either the transmitter FIFO or the transmitter shift register (TSR) contains a data character.
1 = Both the transmitter FIFO and the transmitter shift register (TSR) are empty
*/
///// -------------------- bit 7 -----------------------------
//////// RXFIFOE
/*
0 = There has been no error, or RXFIFOE was cleared because the CPU read the erroneous character from the
receiver FIFO and there are no more errors in the receiver FIFO.
1 = At least one parity error, framing error, or break indicator in the receiver FIFO.
*/
 
 
  
  
  
//////////////// update content of LSR register
always@(posedge clk, posedge rst)
begin
if(rst)
begin
csr.lsr <= 8'h60; //// both fifo and shift register are empty thre = 1 , tempt = 1  // 0110 0000
end
else
begin
csr.lsr.dr <=  ~rx_fifo_empty_i;
csr.lsr.oe <=   rx_oe;
csr.lsr.pe <=   rx_pe;
csr.lsr.fe <=   rx_fe;
csr.lsr.bi <=   rx_bi;
end
end
 
 
 
 
/////////////////read register contents
 
 reg [7:0] lsr_temp; 
 wire read_lsr;
 assign read_lsr = (rd_i == 1) & (addr_i == 3'h5); 
 
 
always@(posedge clk)
begin
 if(read_lsr)
 begin
 lsr_temp <= csr.lsr; 
 end
end
 
//////////////////Scratch pad register
 
 //////////// write new data to lcr
 always @(posedge clk, posedge rst)
   begin
     if(rst)
       begin
       csr.scr <= 8'h00;
       end 
     else if (wr_i == 1'b1 && addr_i == 3'h7)
       begin
       csr.scr <= din_i;
       end
   end
 
 
 
 reg [7:0] scr_temp; 
 wire read_scr;
 assign read_scr = (rd_i == 1) & (addr_i == 3'h7); 
 
 
 
always@(posedge clk)
begin
 if(read_scr)
 begin
 scr_temp <= csr.scr; 
 end
end
 
////////////////////////////////////////////
 
always@(posedge clk)
begin
case(addr_i)
0: dout_o <= csr.lcr.dlab ? dl.dlsb : rx_data;
1: dout_o <= csr.lcr.dlab ? dl.dmsb : 8'h00; /// csr.ier
2: dout_o <= 8'h00; /// iir
3: dout_o <= lcr_temp; /// lcr
4: dout_o <= 8'h00; //mcr;
5: dout_o <= lsr_temp; ///lsr
6: dout_o <= 8'h00; // msr
7: dout_o <= scr_temp; // scr
default: ;
endcase
end
 
 
assign csr_o = csr;
 
endmodule


//////////////////// UART FIFO

module fifo_top(
input rst, clk, en, push_in, pop_in,
input [7:0] din,
output [7:0] dout,
output empty, full, overrun, underrun, 
input [3:0] threshold,
output thre_trigger
);
 
 
reg [7:0] mem [16];
reg [3:0] waddr = 0;
 
 
logic push , pop ;
 
//////////// empty flag
reg empty_t = 0;
always@(posedge clk, posedge rst)
begin
if(rst)
  begin
  empty_t <= 1'b0; 
  end
  else
  begin
    case({push, pop})
     2'b01: empty_t <=  (~|(waddr) | ~en );
     2'b10: empty_t <= 1'b0;
     default : ;
     endcase
  end
 
end
 
 
//////////////////full flag
reg full_t = 0;
always@(posedge clk, posedge rst)
begin
if(rst)
  begin
  full_t <= 1'b0; 
  end
  else
  begin
    case({push, pop})
     2'b10: full_t <=  (&(waddr) | ~en );
     2'b01: full_t <= 1'b0;
     default : ;
     endcase
  end
 
end
 
////////////////////////////////////////////////
 
 
assign push = push_in & ~full_t;
assign pop  = pop_in  & ~empty_t;
 
/////////////// read fifo --> always first element
assign dout = mem[0];
 
 
 
//////////////// write pointer update
always@(posedge clk, posedge rst)
begin
if(rst)
begin
            waddr <= 4'h0;
end
else
begin
         case({push, pop})
         
         2'b10:
             begin
             if(waddr != 4'hf && full_t == 1'b0) 
              waddr <= waddr + 1;
             else
              waddr <= waddr;
            end
        
         2'b01:
             begin
              if(waddr != 0 && empty_t == 1'b0)
              waddr <= waddr - 1;
              else
              waddr <= waddr;
             end
         
         default: ;
         endcase
end
 
end
//////////////////memory update
 
always@(posedge clk)
begin
case({push, pop})
2'b00: ;
 
2'b01: begin //pop 
        for(int i = 0; i < 14; i++)
        begin
        mem[i] <= mem[i+1];
        end
        mem[15] <= 8'h00;
end
 
2'b10 : begin
       mem[waddr] <= din;
end
 
2'b11 :  begin
        for(int i = 0; i < 14; i++)
        begin
        mem[i] <= mem[i+1];
        end
        mem[15] <= 8'h00;
        mem[waddr - 1] <= din;
end
 
endcase
end
 
 
 
 
/////// no read on empty fifo
 
 
 
 
///////////////// underrun
reg underrun_t = 0;
always@(posedge clk, posedge rst)
begin
 if(rst)
  underrun_t <= 1'b0;
 else if(pop_in == 1'b1 && empty_t == 1'b1)
  underrun_t <= 1'b1;
 else
  underrun_t <= 1'b0;
end
////////////////////// overrun
 
reg overrun_t = 1'b0;
 
always@(posedge clk, posedge rst)
begin
if(rst)
   overrun_t <= 1'b0; 
  else if(push_in == 1'b1 && full_t == 1'b1)
   overrun_t <= 1'b1;
  else
   overrun_t <= 1'b0;  
end
 
 
///////////////// threshold
reg thre_t = 0;
always@(posedge clk, posedge rst)
begin
if(rst)
  begin
  thre_t <= 1'b0; 
  end
  else if(push ^ pop) /// 1 1
  begin
  thre_t <= (waddr >= threshold ) ? 1'b1 : 1'b0;
  end
 
end
 
//////////////////
assign empty = empty_t;
assign full = full_t;
assign overrun = overrun_t;
assign underrun = underrun_t;
assign thre_trigger = thre_t; 
 
endmodule


//////////////////// UART TOP

module all_mod(
input clk, rst, wr, rd,
input rx,
input [2:0] addr,
input [7:0] din,
output tx,
output [7:0] dout
    );
 
 csr_t       csr;
 
 wire baud_pulse, pen, thre, stb; 
 
 wire tx_fifo_pop;
 wire [7:0] tx_fifo_out;
 wire tx_fifo_push;
 
 wire r_oe, r_pe, r_fe, r_bi;
 wire rx_fifo_push, rx_fifo_pop;
 
 /////////////UART Registers
regs_uart uart_regs_inst (
    .clk (clk),
    .rst (rst),
    .wr_i (wr),
    .rd_i (rd),
    
    .rx_fifo_empty_i (),
    .rx_oe (),
    .rx_pe (r_pe),
    .rx_fe (r_fe),
    .rx_bi (r_bi),
    
    .addr_i (addr),
    .din_i (din),
    .tx_push_o (tx_fifo_push),
    .rx_pop_o (rx_fifo_pop),
    .baud_out (baud_pulse),
    .tx_rst (tx_rst),
    .rx_rst (rx_rst),
    .rx_fifo_threshold (rx_fifo_threshold),
    .dout_o (dout),
    .csr_o (csr),
    .rx_fifo_in(rx_fifo_out)
);
 
 //////////////TX logic
uart_tx_top uart_tx_inst (
    .clk (clk),
    .rst (rst),
    .baud_pulse (baud_pulse),
    .pen (csr.lcr.pen),
    .thre (1'b0),
    .stb (csr.lcr.stb),
    .sticky_parity (csr.lcr.stick_parity),
    .eps (csr.lcr.eps),
    .set_break (csr.lcr.set_break),
    .din (tx_fifo_out),
    .wls (csr.lcr.wls),
    .pop (tx_fifo_pop),
    .sreg_empty (), ///sreg empty ier
    .tx (tx)
);
 
///////////////// TX FIFO
fifo_top tx_fifo_inst (
    .rst (rst),
    .clk (clk),
    .en (csr.fcr.ena),
    .push_in (tx_fifo_push),
    .pop_in (tx_fifo_pop),
    .din (din),
    .dout (tx_fifo_out),
    .empty (), /// fifo empty ier
    .full (),
    .overrun (),
    .underrun (),
    .threshold (4'h0),
    .thre_trigger ()
);
 
 /////////////RX LOGIC
 
 uart_rx_top uart_rx_inst (
    .clk (clk),
    .rst (rst),
    .baud_pulse (baud_pulse),
    .rx (rx),
    .sticky_parity (csr.lcr.stick_parity),
    .eps (csr.lcr.eps),
    .pen (csr.lcr.pen),
    .wls (csr.lcr.wls),
    .push (rx_fifo_push),
    .pe (r_pe),
    .fe (r_fe),
    .bi (r_bi),
    .dout(rx_out)
);
 
 
////////////// RX FIFO
 
fifo_top rx_fifo_inst (
    .rst (rst),
    .clk (clk),
    .en (csr.fcr.ena),
    .push_in (rx_fifo_push),
    .pop_in (rx_fifo_pop),
    .din (rx_out),
    .dout (rx_fifo_out),
    .empty (), /// fifo empty ier
    .full (),
    .overrun (),
    .underrun (),
    .threshold (rx_fifo_threshold),
    .thre_trigger ()
);
 
 
 
endmodule
