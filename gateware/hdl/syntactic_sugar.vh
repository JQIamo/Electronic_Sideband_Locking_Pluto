//Some macro substitutions that help keeping the code compact.


`define AXI_BUS_STRUCTURE \
        input wire  S_AXI_ACLK,\
		input wire  S_AXI_ARESETN,\
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,\
		input wire [2 : 0] S_AXI_AWPROT,\
		input wire  S_AXI_AWVALID,\
		output wire  S_AXI_AWREADY,\
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,\
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,\
		input wire  S_AXI_WVALID,\
		output wire  S_AXI_WREADY,\
		output wire [1 : 0] S_AXI_BRESP,\
		output wire  S_AXI_BVALID,\
		input wire  S_AXI_BREADY,\
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,\
		input wire [2 : 0] S_AXI_ARPROT,\
		input wire  S_AXI_ARVALID,\
		output wire  S_AXI_ARREADY,\
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,\
		output wire [1 : 0] S_AXI_RRESP,\
		output wire  S_AXI_RVALID,\
		input wire  S_AXI_RREADY

`define AXI_BUS_STRUCTURE_INST \
        .S_AXI_ACLK(S_AXI_ACLK),\
		.S_AXI_ARESETN(S_AXI_ARESETN),\
		.S_AXI_AWADDR(S_AXI_AWADDR),\
		.S_AXI_AWPROT(S_AXI_AWPROT),\
		.S_AXI_AWVALID(S_AXI_AWVALID),\
		.S_AXI_AWREADY(S_AXI_AWREADY),\
		.S_AXI_WDATA(S_AXI_WDATA),\
		.S_AXI_WSTRB(S_AXI_WSTRB),\
		.S_AXI_WVALID(S_AXI_WVALID),\
		.S_AXI_WREADY(S_AXI_WREADY),\
		.S_AXI_BRESP(S_AXI_BRESP),\
		.S_AXI_BVALID(S_AXI_BVALID),\
		.S_AXI_BREADY(S_AXI_BREADY),\
		.S_AXI_ARADDR(S_AXI_ARADDR),\
		.S_AXI_ARPROT(S_AXI_ARPROT),\
		.S_AXI_ARVALID(S_AXI_ARVALID),\
		.S_AXI_ARREADY(S_AXI_ARREADY),\
		.S_AXI_RDATA(S_AXI_RDATA),\
		.S_AXI_RRESP(S_AXI_RRESP),\
		.S_AXI_RVALID(S_AXI_RVALID),\
		.S_AXI_RREADY(S_AXI_RREADY)