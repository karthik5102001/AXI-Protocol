module AXI_Slave_MEM (
	input s_axi_aclk,
	input s_axi_aresetn,
	
	/// Write Address Channel
	input s_axi_awvalid,
	input [31:0] s_axi_awaddr,
	output reg s_axi_awready,


	/// Write Data Channel
	input s_axi_wvalid,
	input [31:0] s_axi_wdata,
	input [3:0] s_axi_wstrb,
	output reg s_axi_wready,

	/// Write Responce Channel
	input s_axi_bready,
	output reg s_axi_bvalid,
	output reg [1:0] s_axi_bresp
);

////  Slave Ready

always @(posedge s_axi_aclk or negedge s_axi_aresetn)
begin
	if(!s_axi_aresetn) begin
		s_axi_awready <= 1'b0;
	end
	else if (s_axi_awready) begin  // Self Kill
		s_axi_awready <= 1'b0;
	end
	else if (s_axi_awvalid) begin
		s_axi_awready <= 1'b1;
	end
end


//// Slave Write Data

always @(posedge s_axi_aclk or negedge s_axi_aresetn)
begin
	if(!s_axi_aresetn) begin
		s_axi_wready <= 1'b0;
	end
	else if (s_axi_wready) begin
		s_axi_wready <= 1'b0;
	end
	else if (s_axi_wvalid) begin
		s_axi_wready <= 1'b1;
	end
end


//// Slave Address

reg [31:0] reg_addr;
reg valid_a;

always @(posedge s_axi_aclk or negedge s_axi_aresetn)
begin
	if(!s_axi_aresetn) begin
		reg_addr <= 32'd0;
		valid_a <= 1'b0;
	end
	else if (s_axi_bvalid) begin
		reg_addr <= 32'd0;
		valid_a <= 1'b0;
	end
	else if (s_axi_awvalid) begin
		reg_addr <= s_axi_awaddr;
		valid_a <= 1'b1;
	end
	end



//// Slave Data

reg [31:0] reg_data;
reg valid_d;

always @(posedge s_axi_aclk or negedge s_axi_aresetn)
begin
	if(!s_axi_aresetn) begin
		reg_data <= 32'd0;
		valid_d <= 1'b0;
	end
	else if(s_axi_bvalid) begin
		reg_data <= 32'd0;
		valid_d <= 1'b0;
	end	
	else if (s_axi_wvalid) begin
		reg_data <= s_axi_wdata;
		valid_d <= 1'b1;
	end
end

//// UPDATE MEMORY

reg [31:0] mem [16:0];
integer i;

always @(posedge s_axi_aclk or negedge s_axi_aresetn)
begin
	if(!s_axi_aresetn) begin
		for(i=0;i<16;i=i+1)
				mem[i] <= 32'd0;
	end
	else if(valid_a && valid_d && reg_addr <= 15) begin
		mem[reg_addr] <= reg_data;
	end
end


//// RESPONCE

always @(posedge s_axi_aclk or negedge s_axi_aresetn)
begin
	if(!s_axi_aresetn) begin
			s_axi_bvalid <= 1'b0;
			s_axi_bresp <= 2'b00;
		end
		else if (valid_a && valid_d && !s_axi_bvalid) begin // if Bvalid is low then we make it high and assign the Bvalid is high with 
				s_axi_bvalid <= 1'b1;					    // Bresp, which indicate the end of transfer
			if(reg_addr <= 15) begin
				s_axi_bresp <= 2'b00;
			end
			else begin
				s_axi_bresp <= 2'b10;
			end
				end
		else if (s_axi_bvalid) begin
				s_axi_bvalid <= 1'b0;
				s_axi_bresp <= 2'b00;
		end
		else begin
				s_axi_bvalid <= 1'b0;
				s_axi_bresp <= 2'b00;
		end
end

endmodule