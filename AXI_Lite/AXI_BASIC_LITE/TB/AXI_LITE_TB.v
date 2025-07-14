
module AXI_MEM_TB();

parameter Delay  = 5;

	 reg m_axi_aclk;
	 reg m_axi_aresetn;
	 reg [31:0] i_data_in;
	 reg [31:0] i_addr_in;
	 reg i_wr_1;
	 reg [3:0] i_strb;
	 wire [31:0] o_error_out;
     wire [1:0] o_resp;
	 wire m_axi_bvalid;

    wire [159:0] pc_asserted;
    wire pc_status;
    
design_1_wrapper DUT
   (i_addr_in,
    i_data_in,
    i_strb,
    i_wr_1,
    m_axi_aclk,
    m_axi_aresetn,
    m_axi_bvalid,
    o_error_out,
    pc_asserted,
    pc_status);

	 initial begin
	m_axi_aclk <= 1'b0;
	m_axi_aresetn <= 1'b0;
	repeat(Delay) @(posedge m_axi_aclk);
	m_axi_aresetn <= 1'b1;	
	repeat(Delay) @(posedge m_axi_aclk);
	i_wr_1 <= 1'b1;
	i_addr_in <= 1;
	i_strb <= 4'hf; 
	i_data_in <= $urandom_range(0,31);
	@(posedge m_axi_bvalid);
	@(posedge m_axi_aclk);
	i_wr_1 <= 1'b1;
	i_addr_in <= 2;
	i_strb <= 4'hf; 
	i_data_in <= $urandom_range(0,31);
	@(posedge m_axi_bvalid);
	@(posedge m_axi_aclk);
	i_wr_1 <= 1'b1;
	i_addr_in <= 3;
	i_strb <= 4'hf; 
	i_data_in <= $random;
	@(posedge m_axi_bvalid);
	@(posedge m_axi_aclk);
	i_wr_1 <= 1'b1;
	i_addr_in <= 4;
	i_strb <= 4'hf; 
	i_data_in <= $urandom_range(0,31);
	@(posedge m_axi_bvalid);
	@(posedge m_axi_aclk);
	i_wr_1 <= 1'b1;
	i_addr_in <= 5;
	i_strb <= 4'hf; 
	i_data_in <= $urandom_range(0,31);
	 @(posedge m_axi_bvalid); 
//	repeat(Delay) @(posedge m_axi_aclk);
	$finish;
	 end

	always #(Delay) m_axi_aclk = ~m_axi_aclk;

	initial begin
		$dumpfile("AXI_MEM.vpd");
		$dumpvars(0,AXI_MEM_TB);
	end

	initial begin
		$dumpfile("AXI_MEM_verdi.fsdb");
		$dumpvars(0,AXI_MEM_TB);
	end


endmodule
