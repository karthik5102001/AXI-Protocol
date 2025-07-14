//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
//Date        : Fri Jul 11 14:57:44 2025
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
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
  input m_axi_aclk;
  input m_axi_aresetn;
  output m_axi_bvalid;
  output [1:0]o_error_out;
  output pc_asserted;
  output [159:0]pc_status;

  wire [31:0]i_addr_in;
  wire [31:0]i_data_in;
  wire [3:0]i_strb;
  wire i_wr_1;
  wire m_axi_aclk;
  wire m_axi_aresetn;
  wire m_axi_bvalid;
  wire [1:0]o_error_out;
  wire pc_asserted;
  wire [159:0]pc_status;

  design_1 design_1_i
       (.i_addr_in(i_addr_in),
        .i_data_in(i_data_in),
        .i_strb(i_strb),
        .i_wr_1(i_wr_1),
        .m_axi_aclk(m_axi_aclk),
        .m_axi_aresetn(m_axi_aresetn),
        .m_axi_bvalid(m_axi_bvalid),
        .o_error_out(o_error_out),
        .pc_asserted(pc_asserted),
        .pc_status(pc_status));
endmodule
