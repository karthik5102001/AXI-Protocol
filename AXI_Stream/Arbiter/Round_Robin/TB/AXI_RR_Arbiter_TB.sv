
module Arbiter_TB();

	parameter Delay = 5;

	 reg Aclk;
	 reg Aresetn;
	 wire s_axis_tready1; // output going to its respected master
	 wire s_axis_tready2;
	 reg s_axis_tvalid1;
	 reg s_axis_tvalid2;
	 reg s_axis_tlast1;
	 reg s_axis_tlast2;
	 reg [7:0] s_axis_tdata1;
	 reg [7:0] s_axis_tdata2;

     reg m_axis_tready;
	 wire m_axis_tlast;
	 wire m_axis_tvalid;
	 wire [7:0] m_axis_tdata;



AXI_Arbiter DUT(Aclk,Aresetn,s_axis_tready1,s_axis_tready2,s_axis_tvalid1,s_axis_tvalid2, s_axis_tlast1,s_axis_tlast2,s_axis_tdata1,s_axis_tdata2,m_axis_tready,m_axis_tlast,m_axis_tvalid, m_axis_tdata);


	initial begin
		Aclk <= 1'b0;
		Aresetn <= 1'b0;
		repeat(5) @(posedge Aclk);
		Aresetn <= 1'b1;
		repeat(5) @(posedge Aclk);

		/// Master 1

		s_axis_tvalid1 <= 1'b1;
		s_axis_tvalid2 <= 1'b0;

		repeat(3)@(posedge Aclk);
		m_axis_tready <= 1'b1;

		repeat(5) begin
		@(posedge Aclk);
		s_axis_tvalid1 <= 1'b1;
		s_axis_tvalid2 <= 1'b0;
		s_axis_tdata1 <= $urandom_range(0,31);
		s_axis_tdata2 <= $urandom_range(0,31);
		s_axis_tlast1 <= 1'b0;
		s_axis_tlast2 <= 1'b0;
				   end
		@(posedge Aclk);
		s_axis_tdata1 <= $urandom_range(0,31);
		s_axis_tlast1 <= 1'b1;
		@(posedge Aclk);
		s_axis_tvalid1 <= 1'b0;
		s_axis_tvalid2 <= 1'b0;
		s_axis_tlast1  <= 1'b0;
//		m_axis_tready <= 1'b0; // dont off (not needed)

		/// Master 2

		s_axis_tvalid1 <= 1'b0;
		s_axis_tvalid2 <= 1'b1;
		repeat(3) @(posedge Aclk);
		m_axis_tready <= 1'b1;

		repeat(5) begin
			@(posedge Aclk);
		s_axis_tvalid1 <= 1'b0;
		s_axis_tvalid2 <= 1'b1;
		s_axis_tdata1 <= $urandom_range(31,51);
		s_axis_tdata2 <= $urandom_range(31,51);
		s_axis_tlast1 <= 1'b0;
		s_axis_tlast2 <= 1'b0;
				   end
		@(posedge Aclk);
		s_axis_tdata2 <= $urandom_range(31,51);
		s_axis_tlast2 <= 1'b1;
		@(posedge Aclk);
		s_axis_tvalid1 <= 1'b0;
		s_axis_tvalid2 <= 1'b0;
		s_axis_tlast2  <= 1'b0;
		m_axis_tready <= 1'b0;

		/// Master 1 and Master 2 same time (if M1 get selected try next M2)

		repeat(5) @(posedge Aclk);

		s_axis_tvalid1 <= 1'b1;
		s_axis_tvalid2 <= 1'b1;

		repeat(3) @(posedge Aclk);
		m_axis_tready <= 1'b1;

		repeat(5) begin
			@(posedge Aclk);
		s_axis_tvalid1 <= 1'b1;
		s_axis_tvalid2 <= 1'b1;
		s_axis_tdata1 <= $urandom_range(31,51);
		s_axis_tdata2 <= $urandom_range(31,51);
		s_axis_tlast1 <= 1'b0;
		s_axis_tlast2 <= 1'b0;
				   end
		@(posedge Aclk);
		s_axis_tdata1 <= $urandom_range(31,51);
		s_axis_tlast1 <= 1'b1;
		@(posedge Aclk);

		///////////////////////////////// send M2 again

		s_axis_tvalid1 <= 1'b0;
		s_axis_tvalid2 <= 1'b1;

		repeat(3) @(posedge Aclk);
		m_axis_tready <= 1'b1;

		repeat(5) begin
		@(posedge Aclk);
		s_axis_tvalid1 <= 1'b0;
		s_axis_tvalid2 <= 1'b1;
		s_axis_tdata1 <= $urandom_range(31,51);
		s_axis_tdata2 <= $urandom_range(31,51);
		s_axis_tlast1 <= 1'b0;
		s_axis_tlast2 <= 1'b0;
				   end
		@(posedge Aclk);
		s_axis_tdata2 <= $urandom_range(31,51);
		s_axis_tlast2 <= 1'b1;
		@(posedge Aclk);
		s_axis_tvalid1 <= 1'b0;
		s_axis_tvalid2 <= 1'b0;
		s_axis_tlast2  <= 1'b0;
		m_axis_tready <= 1'b0;
		
		repeat(10) @(posedge Aclk);

		$finish;
	end

	always #(Delay) Aclk = ~Aclk;

	initial begin
		$dumpfile("wave_vcd.vcd");
		$dumpvars(0,Arbiter_TB);
		end

	initial begin
		$dumpfile("wave_fsdb.fsdb");
    		$dumpvars(0,Arbiter_TB);
		end


endmodule
