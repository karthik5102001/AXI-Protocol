module AXI_FIFO_TB();

	localparam Delay = 5;

	reg Aclk;
	reg Areset_n;

	reg s_axis_tvalid;
	reg [1:0] s_axis_tlast;
	reg [7:0] s_axis_tdata;
	reg s_axis_tkeep;
	wire s_axis_tready; // we keep this one just to make master always ready

    reg m_axis_tready; // is sent by the slave module to read data from fifo
	wire m_axis_tvalid;
	wire m_axis_tlast;
	wire [1:0] m_axis_tkeep;
	wire [7:0] m_axis_tdata;

	AXI_FIFO DUT ( Aclk,Areset_n,s_axis_tvalid,s_axis_tlast,s_axis_tdata,s_axis_tkeep,s_axis_tready,m_axis_tready,m_axis_tvalid,m_axis_tlast,m_axis_tkeep,m_axis_tdata);

	initial begin
		Aclk <= 1'b0;
		Areset_n <= 1'b0;
		repeat(Delay) @(posedge Aclk);
		Areset_n <= 1'b1;
		repeat(Delay) @(posedge Aclk);
	
		// Sent data to fifo by master

		s_axis_tvalid <= 1'b1;
		if(s_axis_tready) begin
				for(int i = 0; i < 20; i++) begin // Full Case
					s_axis_tlast <= 1'b0;
					s_axis_tdata <= $urandom_range(0,31);
					s_axis_tkeep <= 1'b1;
					@(posedge Aclk);
				end
					s_axis_tlast <= 1'b1;
					s_axis_tdata <= $urandom_range(0,31);
		end
			@(posedge Aclk);
			s_axis_tvalid <= 1'b0;
			s_axis_tlast  <= 1'b0;
	
		// Recive data from fifo by slave
	
		repeat(20) begin @(posedge Aclk) // Full Case
		m_axis_tready <= 1'b1; end
		repeat(Delay) @(posedge Aclk);
			m_axis_tready <= 1'b0;
		repeat(Delay) @(posedge Aclk);
			$finish;
	end

	always #(Delay) Aclk <= ~Aclk;

		initial begin
		$dumpfile("wave_fsdb.fsdb");
    	$dumpvars(0,AXI_FIFO_TB);
		end


endmodule