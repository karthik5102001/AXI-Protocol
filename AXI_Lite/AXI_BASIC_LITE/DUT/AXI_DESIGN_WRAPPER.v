//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
//Date        : Fri Jul 11 14:58:24 2025
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=3,numReposBlks=3,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=2,numPkgbdBlks=0,bdsource=USER,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
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
  input [31:0]i_addr_in;
  input [31:0]i_data_in;
  input [3:0]i_strb;
  input i_wr_1;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.M_AXI_ACLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.M_AXI_ACLK, ASSOCIATED_RESET m_axi_aresetn, CLK_DOMAIN design_1_m_axi_aclk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input m_axi_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.M_AXI_ARESETN RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.M_AXI_ARESETN, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input m_axi_aresetn;
  output m_axi_bvalid;
  output [1:0]o_error_out;
  output pc_asserted;
  output [159:0]pc_status;

  wire [31:0]AXI_Master_0_m_axi_awaddr;
  wire AXI_Master_0_m_axi_awvalid;
  wire AXI_Master_0_m_axi_bready;
  wire [31:0]AXI_Master_0_m_axi_wdata;
  wire [3:0]AXI_Master_0_m_axi_wstrb;
  wire AXI_Master_0_m_axi_wvalid;
  wire [1:0]AXI_Master_0_o_error_out;
  wire AXI_Slave_MEM_0_s_axi_awready;
  wire [1:0]AXI_Slave_MEM_0_s_axi_bresp;
  wire AXI_Slave_MEM_0_s_axi_bvalid;
  wire AXI_Slave_MEM_0_s_axi_wready;
  wire axi_protocol_checker_0_pc_asserted;
  wire [159:0]axi_protocol_checker_0_pc_status;
  wire [31:0]i_addr_in_1;
  wire [31:0]i_data_in_1;
  wire [3:0]i_strb_1;
  wire i_wr_1_1;
  wire m_axi_aclk_2;
  wire m_axi_aresetn_1;

  assign i_addr_in_1 = i_addr_in[31:0];
  assign i_data_in_1 = i_data_in[31:0];
  assign i_strb_1 = i_strb[3:0];
  assign i_wr_1_1 = i_wr_1;
  assign m_axi_aclk_2 = m_axi_aclk;
  assign m_axi_aresetn_1 = m_axi_aresetn;
  assign m_axi_bvalid = AXI_Slave_MEM_0_s_axi_bvalid;
  assign o_error_out[1:0] = AXI_Master_0_o_error_out;
  assign pc_asserted = axi_protocol_checker_0_pc_asserted;
  assign pc_status[159:0] = axi_protocol_checker_0_pc_status;
  design_1_AXI_Master_0_0 AXI_Master_0
       (.i_addr_in(i_addr_in_1),
        .i_data_in(i_data_in_1),
        .i_strb(i_strb_1),
        .i_wr(i_wr_1_1),
        .m_axi_aclk(m_axi_aclk_2),
        .m_axi_aresetn(m_axi_aresetn_1),
        .m_axi_awaddr(AXI_Master_0_m_axi_awaddr),
        .m_axi_awready(AXI_Slave_MEM_0_s_axi_awready),
        .m_axi_awvalid(AXI_Master_0_m_axi_awvalid),
        .m_axi_bready(AXI_Master_0_m_axi_bready),
        .m_axi_bresp(AXI_Slave_MEM_0_s_axi_bresp),
        .m_axi_bvalid(AXI_Slave_MEM_0_s_axi_bvalid),
        .m_axi_wdata(AXI_Master_0_m_axi_wdata),
        .m_axi_wready(AXI_Slave_MEM_0_s_axi_wready),
        .m_axi_wstrb(AXI_Master_0_m_axi_wstrb),
        .m_axi_wvalid(AXI_Master_0_m_axi_wvalid),
        .o_error_out(AXI_Master_0_o_error_out));
  design_1_AXI_Slave_MEM_0_0 AXI_Slave_MEM_0
       (.s_axi_aclk(m_axi_aclk_2),
        .s_axi_aresetn(m_axi_aresetn_1),
        .s_axi_awaddr(AXI_Master_0_m_axi_awaddr),
        .s_axi_awready(AXI_Slave_MEM_0_s_axi_awready),
        .s_axi_awvalid(AXI_Master_0_m_axi_awvalid),
        .s_axi_bready(AXI_Master_0_m_axi_bready),
        .s_axi_bresp(AXI_Slave_MEM_0_s_axi_bresp),
        .s_axi_bvalid(AXI_Slave_MEM_0_s_axi_bvalid),
        .s_axi_wdata(AXI_Master_0_m_axi_wdata),
        .s_axi_wready(AXI_Slave_MEM_0_s_axi_wready),
        .s_axi_wstrb(AXI_Master_0_m_axi_wstrb),
        .s_axi_wvalid(AXI_Master_0_m_axi_wvalid));
  design_1_axi_protocol_checker_0_0 axi_protocol_checker_0
       (.aclk(m_axi_aclk_2),
        .aresetn(m_axi_aresetn_1),
        .pc_asserted(axi_protocol_checker_0_pc_asserted),
        .pc_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .pc_axi_arprot({1'b0,1'b0,1'b0}),
        .pc_axi_arready(1'b0),
        .pc_axi_arvalid(1'b0),
        .pc_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .pc_axi_awprot({1'b0,1'b0,1'b0}),
        .pc_axi_awready(1'b0),
        .pc_axi_awvalid(1'b0),
        .pc_axi_bready(1'b0),
        .pc_axi_bresp({1'b0,1'b0}),
        .pc_axi_bvalid(1'b0),
        .pc_axi_rdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .pc_axi_rready(1'b0),
        .pc_axi_rresp({1'b0,1'b0}),
        .pc_axi_rvalid(1'b0),
        .pc_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .pc_axi_wready(1'b0),
        .pc_axi_wstrb({1'b1,1'b1,1'b1,1'b1}),
        .pc_axi_wvalid(1'b0),
        .pc_status(axi_protocol_checker_0_pc_status));
endmodule
