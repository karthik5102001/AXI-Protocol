// Simulation : Done
// Lint Check : Pending
// STA Analysis : Pending
// Synthesis : Pending
// Description : AXI Round Robin Arbiter
// Author : Karthik
// Date : 2025-07-06


module AXI_Arbiter (
	input wire Aclk,
	input wire Areset_n,
	output reg s_axis_tready1, // output going to its respected master1 (anyways we keep this high always)
	output reg s_axis_tready2, // output going to its respected master2 (anyways we keep this high always)
	input wire s_axis_tvalid1, // First Priority 
	input wire s_axis_tvalid2, // Second Priority 
	input wire s_axis_tlast1,
	input wire s_axis_tlast2,
	input wire [7:0] s_axis_tdata1, 
	input wire [7:0] s_axis_tdata2,

	input wire m_axis_tready, // From the Slave side to Arbiter 
	output reg m_axis_tlast,  // From Arbiter to Slave side 
	output reg m_axis_tvalid, // From Arbiter to Slave side
	output reg [7:0] m_axis_tdata // From Arbiter to Slave side
);

typedef enum bit [1:0] {idle = 2'b00, s1 = 2'b01, s2 = 2'b10} state_reg;
state_reg state, next_state;

assign s_axis_tready1 = 1'b1;  // we assign one to the master part for lower  
assign s_axis_tready2 = 1'b1;  // the time compution

always_ff @(posedge Aclk or negedge Areset_n)
begin
	if(!Areset_n)
	begin
		state <= idle;
	end
	else begin
		state <= next_state;
	end
end

reg [7:0] reg_data;
reg reg_last;

always_comb begin
	case(state)
			idle : begin
					if(s_axis_tvalid1 && s_axis_tready1)begin
						next_state  = s1;
						reg_data = s_axis_tdata1;   // we will hold our data when we jump form 
						reg_last = s_axis_tlast1;	// idle to S1
					end
					else if(s_axis_tvalid2 && s_axis_tready2)begin
						next_state  = s2;
						reg_data = s_axis_tdata2;  // we will hold our data when we jump form
						reg_last = s_axis_tlast2;  // idle to S2
					end
					else next_state = idle;
			end
			s1 	: begin
					if(m_axis_tready) begin
						if(s_axis_tlast1) begin
							reg_data = s_axis_tdata1;
							reg_last = s_axis_tlast1;
								if(s_axis_tvalid2 && s_axis_tready2)
								begin
									next_state = s2; // if we have responce from other master(M2)
									end				 // then we go to S2
								else begin
									next_state = idle;
									end
							end
						else begin
							next_state = s1;
							reg_data = s_axis_tdata1;
							reg_last = s_axis_tlast1;
								end
						end
				else next_state = s1;
					end
		
				s2 	: begin
					if(m_axis_tready) begin
						if(s_axis_tlast2) begin
							reg_data = s_axis_tdata2;
							reg_last = s_axis_tlast2;
								if(s_axis_tvalid1 && s_axis_tready1)
								begin
									next_state = s1;// if we have responce from other master(M1)
								end					// then we go to S1
								else begin
									next_state = idle;
								end
							end
						else begin
							next_state = s2;
							reg_data = s_axis_tdata2;
							reg_last = s_axis_tlast2;
								end
						end
				else next_state = s2;
					end
	
		 default : begin
					next_state = idle;
		 end
		endcase			
		end

assign m_axis_tdata  = ((s_axis_tvalid1 && s_axis_tready1)||(s_axis_tvalid2 && s_axis_tready2)) ? reg_data : 8'h00;
assign m_axis_tvalid = ((s_axis_tvalid1 && s_axis_tready1)||(s_axis_tvalid2 && s_axis_tready2)) ? 1'b1 : 1'b0;
assign m_axis_tlast  = ((s_axis_tvalid1 && s_axis_tready1)||(s_axis_tvalid2 && s_axis_tready2)) ? reg_last : 1'b0;

endmodule
