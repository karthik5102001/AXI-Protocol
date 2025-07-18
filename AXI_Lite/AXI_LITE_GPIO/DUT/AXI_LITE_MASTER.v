
module AXI_Master (
input wire valid_in,
input wire wr_in,
input wire [31:0] write_addr,
input wire [31:0] write_data,
input wire [3:0] write_strb,
output reg [1:0] write_resp,
output reg [1:0] read_resp,
input wire [31:0] read_addr,
output reg [31:0] read_data_out, 
output reg wr_timeout,
output reg rd_timeout,

/// AXI Master to Slave Signals

input wire m_axi_aclock,
input wire m_axi_areset,

/// AXI write address

output reg [31:0] m_axi_awaddr,
output reg        m_axi_awvalid,
input  wire        m_axi_awready,

/// AXI write data

output reg [31:0] m_axi_wdata,
output reg        m_axi_wvalid,
output reg [3:0]  m_axi_wstrb,
input  wire       m_axi_wready,

/// AXI  write responce

output reg  m_axi_bready,
input wire  [1:0] m_axi_bresp,
input wire  m_axi_bvalid,     

/// AXI Read addr

output reg [31:0] m_axi_araddr,
output reg m_axi_arvalid,
input wire m_axi_arready,

/// AXI Read ack + Read Data

// output reg [31:0] m_axi_raddr,
input  wire        m_axi_rvalid,
output reg        m_axi_rready,

input  wire [31:0]  m_axi_rdata,
input  wire [1:0] m_axi_rresp
);

////   Write Logic FSM
                                                                                                                                
parameter wr_idle = 1,
          wait_for_op = 2,
          wraddr_write = 3,
          wait_for_wdata_ack = 4,
          wait_for_write_resp = 5,
          no_ack_wdata = 6,
          no_ack_waddr = 7,
          no_slave_wr_resp = 8,
          complete_write_trans = 9; 
          
reg [3:0] state_wr;
reg [3:0] nxt_state_wr;
reg [3:0] counter_wr;
          
/// Reset Decoding 

always @(posedge m_axi_aclock or negedge m_axi_areset) begin
  if (m_axi_areset == 1'b0)
    state_wr <= wr_idle;
  else
    state_wr <= nxt_state_wr;     
end

/// Next state_wr Logic

always @(*) begin
   case(state_wr)
   wr_idle : begin
               m_axi_awaddr     <= 32'd0;
               m_axi_awvalid    <= 1'b0;
               m_axi_wdata      <= 32'd0;
               m_axi_wvalid     <= 1'b0;
               m_axi_wstrb      <= 4'd0;
               m_axi_bready     <= 1'b0;
               counter_wr          <= 4'd0;
               wr_timeout       <= 1'b0; 
               if(valid_in) nxt_state_wr <= wait_for_op;
               else nxt_state_wr <= wr_idle;
   end 
   
   wait_for_op : begin
                if(wr_in) nxt_state_wr <= wraddr_write;
                else nxt_state_wr <= wr_idle;
   end 
   
   wraddr_write : begin
               m_axi_awaddr     <= write_addr;
               m_axi_awvalid    <= 1'b1;
               m_axi_wdata      <= write_data;
               m_axi_wvalid     <= 1'b1;
               m_axi_wstrb      <= write_strb;
               m_axi_bready     <= 1'b1;
               if(m_axi_awready && m_axi_wready && m_axi_bvalid) begin nxt_state_wr <= complete_write_trans; write_resp = m_axi_bresp; end  // If we get all the responce just jump to complete
               else if(m_axi_awready && m_axi_wready)    nxt_state_wr <= wait_for_write_resp;        // if only address and data of write ready responce is then wait for write responce
               else if(m_axi_awready) nxt_state_wr <= wait_for_wdata_ack;           // if we get only write address ready responce we wait for write data ready responce
               else if (counter_wr == 15) nxt_state_wr <= no_ack_waddr;             // if none of the responce are recived then we wait till the count reaches 15
               else nxt_state_wr <= wraddr_write;                                   // if none of the responce are recived then we increment the count
   end
   
   wait_for_wdata_ack : begin
              m_axi_awaddr     <= 32'd0;                                            // we make the write address as low because we got its ready responce at previous state 
              m_axi_awvalid    <= 1'b0;                                             // we make the write valid as low because we got its ready responce at previous state     
              if(m_axi_wready) nxt_state_wr <=  wait_for_write_resp;                // if we get the write data responce then we can wait for write bvalid responce as we jumped here when we got w addr resp 
              else if (counter_wr == 15) nxt_state_wr <= no_ack_wdata;              // if none of the responce are recived then we wait till the count reaches 15
              else nxt_state_wr <= wait_for_wdata_ack;                              // if none of the responce are recived then we increment the count
   end
   
   wait_for_write_resp : begin
               m_axi_awaddr     <= 32'd0;
               m_axi_awvalid    <= 1'b0;                                            // we got address and data ready responce we make address and data valid low and wait for write responce
               m_axi_wdata      <= 32'd0;
               m_axi_wvalid     <= 1'b0;
               if(m_axi_bvalid)begin nxt_state_wr <= complete_write_trans; write_resp = m_axi_bresp; end    // if we get the write valid resp we jump to complete trans
               else if (counter_wr == 15) nxt_state_wr <= no_slave_wr_resp;
               else   nxt_state_wr <=  wait_for_write_resp;   
   end
    
   no_ack_wdata, no_ack_waddr : begin
               wr_timeout <= 1'b1;
               if(m_axi_bvalid)  begin nxt_state_wr <= complete_write_trans; write_resp = m_axi_bresp; end  // if we get the write responce we jump to complete transfer (it shows that we didnt get resp form data
               else if (counter_wr == 15)  nxt_state_wr <= no_slave_wr_resp;                                //   as well as address of write channel )
   end
   
   no_slave_wr_resp : begin
                wr_timeout <= 1'b1;                         // we didnt get any responce signal so timeout is held high
                nxt_state_wr <= wr_idle; 
   end
   
   complete_write_trans : begin
                 nxt_state_wr <= wr_idle;
                 m_axi_bready <= 1'b0;
                 m_axi_awvalid    <= 1'b0;                                            // we got address and data ready responce we make address and data valid low and wait for write responce
   end
   default : nxt_state_wr <= wr_idle;
  endcase
end

wire current_state_wr_shift = (state_wr != nxt_state_wr) ? 1'b1 : 1'b0;     // we make it high when state changes only
reg next_state_wr_shift;

always @(posedge m_axi_aclock or negedge m_axi_areset)begin
    if(!m_axi_areset) next_state_wr_shift <= 1'b0;          
    else next_state_wr_shift <= current_state_wr_shift;                    // we store it to extract count logic
end

///// counter_wr Logic for write

always @(posedge m_axi_aclock)
begin
    case(state_wr)
    wr_idle : counter_wr <= 4'b0000;
    wait_for_op : counter_wr <= 4'b0000;
    wraddr_write : counter_wr <= counter_wr + 4'b0001;
    wait_for_wdata_ack : begin
                if(next_state_wr_shift) counter_wr <= 4'b0000;              // if we have shift in state we clear the counter indicating that we got some required signals
                else counter_wr <= counter_wr + 4'b0001; 
    end
    wait_for_write_resp : begin
                if(next_state_wr_shift) counter_wr <= 4'b0000;             // if we have shift in state we clear the counter indicating that we got some required signals
                else counter_wr <= counter_wr + 4'b0001;
    end
    no_ack_wdata : begin
                 if(next_state_wr_shift) counter_wr <= 4'b0000;           // if we have shift in state we clear the counter indicating that we got some required signals
                else counter_wr <= counter_wr + 4'b0001;
    end
    no_ack_waddr : begin
                 if(next_state_wr_shift) counter_wr <= 4'b0000;           // if we have shift in state we clear the counter indicating that we got some required signals
                else counter_wr <= counter_wr + 4'b0001;
    end
    no_slave_wr_resp : counter_wr <= 4'b0000;
    complete_write_trans : counter_wr <= 4'b0000;
    default : counter_wr <= 4'b0000;
    endcase
end

////   Read Logic FSM

parameter rd_idle = 0,
          wait_for_read_op = 1,
          raddr_write = 2,
          wait_for_rdata = 3,
          no_resp_raddr = 4,
          no_resp_rdata = 5,
          complete_rx_trans = 6;
          
reg [2:0] state_rd;
reg [2:0] nxt_state_rd;  
reg [3:0] counter_rd;

//// Reset Logic

always @(posedge m_axi_aclock or negedge m_axi_areset)
begin
    if(!m_axi_areset)
        state_rd <= rd_idle;
    else state_rd <= nxt_state_rd;
end

//// Next State Logic

always @(*) begin
case(state_rd)
    rd_idle : begin 
      m_axi_arvalid <= 1'b0;
      m_axi_araddr <= 32'd0;
      m_axi_rready <= 1'b0;
      read_data_out <= 32'd0;
      read_resp    <= 2'b00;
      rd_timeout  <= 1'b0;
      if(valid_in) nxt_state_rd <= wait_for_read_op;
               else nxt_state_rd <= rd_idle;
    end
    wait_for_read_op : begin
        if(wr_in == 1'b0) nxt_state_rd <= raddr_write ;
        else nxt_state_rd <= rd_idle;
    end
    raddr_write : begin
        m_axi_arvalid <= 1'b1;
        m_axi_araddr <= read_addr; 
        m_axi_rready <= 1'b1;
        if(m_axi_arready && m_axi_rvalid) begin nxt_state_rd <= complete_rx_trans; read_resp <= m_axi_rresp; end    // if we get read ready and read valid signal just finish the transfer
        else if (m_axi_arready) nxt_state_rd <= wait_for_rdata;                          // if we get read address ready we wait for read data ready
        else if (counter_rd == 15) nxt_state_rd <= no_resp_raddr;
        else nxt_state_rd <= raddr_write;
    end
    wait_for_rdata : begin
        m_axi_arvalid <= 1'b0;
        m_axi_araddr <= 32'd0;
        if(m_axi_rvalid) begin nxt_state_rd <= complete_rx_trans; read_resp <= m_axi_rresp; end       // if we get the read valid responce we declare it as complete responce
        else if(counter_rd == 15)  nxt_state_rd <= no_resp_rdata;
    end
    no_resp_raddr : begin
        rd_timeout <= 1'b1;
      nxt_state_rd <= rd_idle;
    end
    no_resp_rdata : begin
        rd_timeout <= 1'b1;
      nxt_state_rd <= rd_idle;
    end
    complete_rx_trans : begin
        m_axi_rready <= 1'b0;
        m_axi_arvalid <= 1'b0;
        m_axi_araddr <= 32'd0;
        read_data_out <= m_axi_rdata;
        read_resp <= m_axi_rresp;
              nxt_state_rd <= rd_idle;
    end
    default : nxt_state_rd <= rd_idle;
    endcase 
end

//// Counter Logic

wire current_state_rd_shift = (state_rd != nxt_state_rd) ? 1'b1 : 1'b0;
reg next_state_rd_shift;

always @(posedge m_axi_aclock or negedge m_axi_areset)begin
    if(!m_axi_areset) next_state_rd_shift <= 1'b0;
    else next_state_rd_shift <= current_state_rd_shift;
end


always @(posedge m_axi_aclock) begin
case(state_rd)
    rd_idle : begin 
        counter_rd <= 3'b000;
    end
    wait_for_read_op : begin
        counter_rd <= 3'b000;
    end
    raddr_write : begin
         counter_rd <= counter_rd + 3'b001;
    end
    wait_for_rdata : begin
        if(next_state_rd_shift) counter_rd <= 3'b000;
                else counter_rd <= counter_rd + 3'b001;
    end
    no_resp_raddr : begin
         counter_rd <= 3'b000;
    end
    no_resp_rdata : begin
         counter_rd <= 3'b000;
    end
    complete_rx_trans : begin
        counter_rd <= 3'b000;
    end
    default : counter_rd <= 3'b000;
    endcase 
end
endmodule

