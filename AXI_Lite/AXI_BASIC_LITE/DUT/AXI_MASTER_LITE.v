module AXI_Master (
		input m_axi_aclk, m_axi_aresetn, i_wr,
		input [31:0] i_addr_in, i_data_in,
		input [3:0] i_strb,
		output reg [1:0] o_error_out,

		/// Write Address
		output reg m_axi_awvalid,
		output reg[31:0] m_axi_awaddr,
		input m_axi_awready,

		/// Write Data
		output reg[31:0] m_axi_wdata,
		output reg[3:0] m_axi_wstrb,
		output reg m_axi_wvalid,
		input m_axi_wready,

		/// Write Responce
		input m_axi_bvalid,
		input [1:0] m_axi_bresp,
		output reg m_axi_bready
);


//// Bready will be low at first, when we set Bready high is i_wr is high (indicates write)
//// once Bready is high we wait for current transfer responce. 
//// So we are implementing Single Beat Without Pipelining.


/// ----              VALID SIGNAL        ---- ////

always  @(posedge m_axi_aclk or negedge m_axi_aresetn) begin
	if(! m_axi_aresetn)
	begin
		{m_axi_awvalid,m_axi_wvalid,m_axi_bready} <= 3'b000;
	end
	else if (m_axi_bready) begin
			if(m_axi_awready)  m_axi_awvalid <= 1'b0;
			if(m_axi_wready)   m_axi_wvalid <= 1'b0;
			if(m_axi_bvalid)   m_axi_bready <= 1'b0;
	end
	else if (i_wr) begin
				{m_axi_awvalid,m_axi_wvalid,m_axi_bready} <= 3'b111;
	end
end

//// ----           ADDRESS SIGNALS         ---- ///

always @(posedge m_axi_aclk or negedge m_axi_aresetn) begin
	if(! m_axi_aresetn)begin
			m_axi_awaddr <= 32'd0;
	end
	else if (i_wr) begin
				m_axi_awaddr <= i_addr_in;
	end
	else if (m_axi_awvalid && m_axi_awready && m_axi_bvalid) begin
					m_axi_awaddr <= 32'd0;
	end
end

//// ----           DATA SIGNALS           ---- ///

always  @(posedge m_axi_aclk or negedge m_axi_aresetn) begin
	if(! m_axi_aresetn) begin
			m_axi_wdata <= 32'd0;
			m_axi_wstrb <= 32'd0;
	end
	else if (i_wr) begin
			m_axi_wdata <= i_data_in;
			m_axi_wstrb <= i_strb;
	end
	else if (m_axi_awvalid && m_axi_awready && m_axi_bvalid) begin
			m_axi_wdata <= 32'd0;
			m_axi_wstrb <= 32'd0;
	end
end

//// ----          RESPONCE SIGNALS           ---- ///

always  @(posedge m_axi_aclk or negedge m_axi_aresetn) begin
	if(! m_axi_aresetn) begin
			o_error_out <= 2'b00;  /// OKAY
		end
		else if (m_axi_bvalid) begin
			o_error_out <= m_axi_bresp;
		end
end

endmodule