// Simulation : Done
// Lint Check : Pending
// STA Analysis : Pending
// Synthesis : Pending
// Description : AXI FIFO for AXI Stream Interface
// Author : Karthik
// Date : 2025-07-06

module AXI_FIFO(
	input wire Aclk,
	input wire Areset_n,

	input wire s_axis_tvalid,
	input wire s_axis_tlast,
	input wire [7:0] s_axis_tdata,
	input wire [1:0] s_axis_tkeep,
	output wire s_axis_tready, // we keep this one just to make master always ready

	input wire m_axis_tready, // is sent by the slave module to read data from fifo
	output reg m_axis_tvalid,
	output reg m_axis_tlast,
	output reg [1:0] m_axis_tkeep,
	output reg [7:0] m_axis_tdata
);

reg mem_l[16];
reg mem_k[16];
reg [7:0] mem_d[16];

reg [4:0] w_ptr;
reg [4:0] r_ptr;
reg [4:0] count;

wire full,empty;

assign full = (w_ptr==5'd15) ? 1'b1 : 1'b0;
assign empty = (r_ptr==5'd15) ? 1'b1 : 1'b0;
assign s_axis_tready =  1'b1;

always_ff @(posedge Aclk or negedge Areset_n)
begin
	if(!Areset_n) begin
		w_ptr <= 5'd0;
		r_ptr <= 5'd0;
		count <= 5'd0;
	//	m_axis_tvalid <= 1'b0;
	//	m_axis_tlast <= 1'b0;
	//	m_axis_tkeep <= 2'b00;
	//	m_axis_tdata <= 8'h00;
		for(int i=0 ; i<=5'd16; i++) begin
				mem_d[i] <= 8'h00;
				mem_l[i] <= 1'b0;
				mem_k[i] <= 2'b00;
		end
	end
	else if (s_axis_tvalid && !full) begin
		mem_d[w_ptr] <= s_axis_tdata;
		mem_k[w_ptr] <= s_axis_tkeep;
		mem_l[w_ptr] <= s_axis_tlast;
		w_ptr <= w_ptr + 5'h1;
		count <= count + 5'h1;
	//	m_axis_tvalid <= 1'b0;
	//	m_axis_tlast <= 1'b0;
   //	m_axis_tkeep <= 2'b00;
//		m_axis_tdata <= 8'h00;
	end
	else if (m_axis_tready && !empty) begin // if we use the tready signal before tvalid it violates the AXI Protocol
		r_ptr <= r_ptr + 5'h1; 				// We will update the tvalid first when count becomes >0 then we read the
		count <= count - 5'h1;				// data when ever we want by making tready high
		end
end


assign m_axis_tdata = (m_axis_tvalid) ? mem_d[r_ptr] : 8'h00;
assign m_axis_tlast = (m_axis_tvalid) ? mem_l[r_ptr] : 8'h00;
assign m_axis_tkeep = (m_axis_tvalid) ? mem_k[r_ptr] : 8'h00;
assign m_axis_tvalid = (count > 0) ? 1'b1 : 1'b0;



endmodule