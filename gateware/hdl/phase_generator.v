/* Machine-generated using Migen */
module phase_generator(
	input [31:0] f,
	input clr,
	input [7:0] multiplier,
	input [21:0] phase,
	input [15:0] i_amp,
	input [15:0] q_amp,
	output reg [15:0] i,
	output reg [15:0] q,
	input [19:0] phase_PDH,
	output reg [7:0] pdh_output,
	input sys_clk,
	input sys_rst
);

reg [19:0] accu_p = 20'd0;
reg [19:0] accu_z0 = 20'd0;
reg [19:0] accu_z1 = 20'd0;
reg [19:0] accu_z2 = 20'd0;
reg [19:0] accu_z3 = 20'd0;
reg [19:0] accu_z4 = 20'd0;
reg [19:0] accu_z5 = 20'd0;
reg [19:0] accu_z6 = 20'd0;
reg [19:0] accu_z7 = 20'd0;
reg [31:0] accu_i = 32'd0;
wire [31:0] accu_mcm0;
wire [31:0] accu_mcm1;
wire [31:0] accu_mcm2;
wire [31:0] accu_mcm3;
wire [31:0] accu_mcm4;
wire [31:0] accu_mcm5;
wire [31:0] accu_mcm6;
wire [31:0] accu_mcm7;
reg [31:0] accu_qa = 32'd0;
reg [31:0] accu_qb = 32'd0;
reg accu_clr_d = 1'd0;
reg [16:0] cs_carrier_z = 17'd0;
wire signed [13:0] cs_carrier_x;
wire signed [13:0] cs_carrier_y;
reg [11:0] cs_carrier_lut_data_x = 12'd0;
reg [12:0] cs_carrier_lut_data_y = 13'd0;
reg [2:0] cs_carrier_lut_data_xd = 3'd0;
reg [3:0] cs_carrier_lut_data_yd = 4'd0;
wire [8:0] cs_carrier_adr;
wire [31:0] cs_carrier_dat_r;
wire [13:0] cs_carrier_za;
wire signed [5:0] cs_carrier_zd;
wire signed [5:0] cs_carrier_zd_cossingen0;
reg signed [5:0] cs_carrier_zd_cossingen1 = 6'sd0;
reg signed [5:0] cs_carrier_zd_cossingen2 = 6'sd0;
reg signed [8:0] cs_carrier_lxd = 9'sd0;
reg signed [8:0] cs_carrier_lyd = 9'sd0;
wire [12:0] cs_carrier_cossingen0;
reg [12:0] cs_carrier_cossingen1 = 13'd0;
wire signed [14:0] cs_carrier_x1_cossingen0;
reg signed [14:0] cs_carrier_x1_cossingen1 = 15'sd0;
wire [12:0] cs_carrier_cossingen2;
reg [12:0] cs_carrier_cossingen3 = 13'd0;
wire signed [14:0] cs_carrier_y1_cossingen0;
reg signed [14:0] cs_carrier_y1_cossingen1 = 15'sd0;
wire [2:0] cs_carrier_zq_cossingen0;
reg [2:0] cs_carrier_zq_cossingen1 = 3'd0;
reg [2:0] cs_carrier_zq_cossingen2 = 3'd0;
reg [2:0] cs_carrier_zq_cossingen3 = 3'd0;
reg [2:0] cs_carrier_zq_cossingen4 = 3'd0;
wire signed [14:0] cs_carrier_x2_cossingen;
wire signed [14:0] cs_carrier_y2_cossingen;
reg [21:0] modulation = 22'd0;
reg [21:0] cs_sine_z = 22'd0;
wire signed [16:0] cs_sine_x;
wire signed [16:0] cs_sine_y;
reg [14:0] cs_sine_lut_data_x = 15'd0;
reg [15:0] cs_sine_lut_data_y = 16'd0;
reg [2:0] cs_sine_lut_data_xd = 3'd0;
reg [3:0] cs_sine_lut_data_yd = 4'd0;
wire [8:0] cs_sine_adr;
wire [37:0] cs_sine_dat_r;
wire [18:0] cs_sine_za;
wire signed [10:0] cs_sine_zd;
wire signed [10:0] cs_sine_zd_cossingen0;
reg signed [10:0] cs_sine_zd_cossingen1 = 11'sd0;
reg signed [10:0] cs_sine_zd_cossingen2 = 11'sd0;
reg signed [13:0] cs_sine_lxd = 14'sd0;
reg signed [13:0] cs_sine_lyd = 14'sd0;
wire [15:0] cs_sine_cossingen0;
reg [15:0] cs_sine_cossingen1 = 16'd0;
wire signed [17:0] cs_sine_x1_cossingen0;
reg signed [17:0] cs_sine_x1_cossingen1 = 18'sd0;
wire [15:0] cs_sine_cossingen2;
reg [15:0] cs_sine_cossingen3 = 16'd0;
wire signed [17:0] cs_sine_y1_cossingen0;
reg signed [17:0] cs_sine_y1_cossingen1 = 18'sd0;
wire [2:0] cs_sine_zq_cossingen0;
reg [2:0] cs_sine_zq_cossingen1 = 3'd0;
reg [2:0] cs_sine_zq_cossingen2 = 3'd0;
reg [2:0] cs_sine_zq_cossingen3 = 3'd0;
reg [2:0] cs_sine_zq_cossingen4 = 3'd0;
wire signed [17:0] cs_sine_x2_cossingen;
wire signed [17:0] cs_sine_y2_cossingen;
reg [21:0] cs_cosine_z = 22'd0;
wire signed [16:0] cs_cosine_x;
wire signed [16:0] cs_cosine_y;
reg [14:0] cs_cosine_lut_data_x = 15'd0;
reg [15:0] cs_cosine_lut_data_y = 16'd0;
reg [2:0] cs_cosine_lut_data_xd = 3'd0;
reg [3:0] cs_cosine_lut_data_yd = 4'd0;
wire [8:0] cs_cosine_adr;
wire [37:0] cs_cosine_dat_r;
wire [18:0] cs_cosine_za;
wire signed [10:0] cs_cosine_zd;
wire signed [10:0] cs_cosine_zd_cossingen0;
reg signed [10:0] cs_cosine_zd_cossingen1 = 11'sd0;
reg signed [10:0] cs_cosine_zd_cossingen2 = 11'sd0;
reg signed [13:0] cs_cosine_lxd = 14'sd0;
reg signed [13:0] cs_cosine_lyd = 14'sd0;
wire [15:0] cs_cosine_cossingen0;
reg [15:0] cs_cosine_cossingen1 = 16'd0;
wire signed [17:0] cs_cosine_x1_cossingen0;
reg signed [17:0] cs_cosine_x1_cossingen1 = 18'sd0;
wire [15:0] cs_cosine_cossingen2;
reg [15:0] cs_cosine_cossingen3 = 16'd0;
wire signed [17:0] cs_cosine_y1_cossingen0;
reg signed [17:0] cs_cosine_y1_cossingen1 = 18'sd0;
wire [2:0] cs_cosine_zq_cossingen0;
reg [2:0] cs_cosine_zq_cossingen1 = 3'd0;
reg [2:0] cs_cosine_zq_cossingen2 = 3'd0;
reg [2:0] cs_cosine_zq_cossingen3 = 3'd0;
reg [2:0] cs_cosine_zq_cossingen4 = 3'd0;
wire signed [17:0] cs_cosine_x2_cossingen;
wire signed [17:0] cs_cosine_y2_cossingen;
reg [32:0] output_i_scaled = 33'd0;
reg [32:0] output_q_scaled = 33'd0;
reg [19:0] pdh_accumulator0 = 20'd0;
reg [19:0] pdh_accumulator1 = 20'd0;
reg [19:0] pdh_accumulator2 = 20'd0;
reg [19:0] pdh_accumulator3 = 20'd0;
reg [19:0] pdh_accumulator4 = 20'd0;
reg [19:0] pdh_accumulator5 = 20'd0;
reg [19:0] pdh_accumulator6 = 20'd0;
reg [19:0] pdh_accumulator7 = 20'd0;
wire [32:0] slice_proxy0;
wire [32:0] slice_proxy1;
wire [32:0] slice_proxy2;
wire [32:0] slice_proxy3;
wire [32:0] slice_proxy4;
wire [32:0] slice_proxy5;
wire [32:0] slice_proxy6;
wire [32:0] slice_proxy7;

// synthesis translate_off
reg dummy_s;
initial dummy_s <= 1'd0;
// synthesis translate_on

assign accu_mcm0 = 1'd0;
assign accu_mcm1 = accu_i;
assign accu_mcm2 = (accu_i <<< 1'd1);
assign accu_mcm3 = (accu_i + (accu_i <<< 1'd1));
assign accu_mcm4 = (accu_i <<< 2'd2);
assign accu_mcm5 = (accu_i + (accu_i <<< 2'd2));
assign accu_mcm6 = (accu_mcm3 <<< 1'd1);
assign accu_mcm7 = ((accu_i <<< 2'd3) - accu_i);
assign cs_carrier_za = (cs_carrier_z[14] ? (14'd16383 - cs_carrier_z[13:0]) : cs_carrier_z[13:0]);
assign cs_carrier_adr = cs_carrier_za[13:5];
assign cs_carrier_zd = ((cs_carrier_za[4:0] - 5'd16) + cs_carrier_z[14]);
assign cs_carrier_zd_cossingen0 = cs_carrier_zd;
assign cs_carrier_cossingen0 = (cs_carrier_lut_data_x | 13'd4096);
assign cs_carrier_x1_cossingen0 = ($signed({1'd0, cs_carrier_cossingen1}) - ((cs_carrier_lyd + $signed({1'd0, 4'd15})) >>> 3'd5));
assign cs_carrier_cossingen2 = cs_carrier_lut_data_y;
assign cs_carrier_y1_cossingen0 = ($signed({1'd0, cs_carrier_cossingen3}) + ((cs_carrier_lxd + $signed({1'd0, 4'd15})) >>> 3'd5));
assign cs_carrier_zq_cossingen0 = {cs_carrier_z[16], (cs_carrier_z[15] ^ cs_carrier_z[16]), (cs_carrier_z[14] ^ cs_carrier_z[15])};
assign cs_carrier_x2_cossingen = (cs_carrier_zq_cossingen4[0] ? cs_carrier_y1_cossingen1 : cs_carrier_x1_cossingen1);
assign cs_carrier_y2_cossingen = (cs_carrier_zq_cossingen4[0] ? cs_carrier_x1_cossingen1 : cs_carrier_y1_cossingen1);
assign cs_carrier_x = (cs_carrier_zq_cossingen4[1] ? (-cs_carrier_x2_cossingen) : cs_carrier_x2_cossingen);
assign cs_carrier_y = (cs_carrier_zq_cossingen4[2] ? (-cs_carrier_y2_cossingen) : cs_carrier_y2_cossingen);
assign cs_sine_za = (cs_sine_z[19] ? (19'd524287 - cs_sine_z[18:0]) : cs_sine_z[18:0]);
assign cs_sine_adr = cs_sine_za[18:10];
assign cs_sine_zd = ((cs_sine_za[9:0] - 10'd512) + cs_sine_z[19]);
assign cs_sine_zd_cossingen0 = cs_sine_zd;
assign cs_sine_cossingen0 = (cs_sine_lut_data_x | 16'd32768);
assign cs_sine_x1_cossingen0 = ($signed({1'd0, cs_sine_cossingen1}) - ((cs_sine_lyd + $signed({1'd0, 6'd63})) >>> 3'd7));
assign cs_sine_cossingen2 = cs_sine_lut_data_y;
assign cs_sine_y1_cossingen0 = ($signed({1'd0, cs_sine_cossingen3}) + ((cs_sine_lxd + $signed({1'd0, 6'd63})) >>> 3'd7));
assign cs_sine_zq_cossingen0 = {cs_sine_z[21], (cs_sine_z[20] ^ cs_sine_z[21]), (cs_sine_z[19] ^ cs_sine_z[20])};
assign cs_sine_x2_cossingen = (cs_sine_zq_cossingen4[0] ? cs_sine_y1_cossingen1 : cs_sine_x1_cossingen1);
assign cs_sine_y2_cossingen = (cs_sine_zq_cossingen4[0] ? cs_sine_x1_cossingen1 : cs_sine_y1_cossingen1);
assign cs_sine_x = (cs_sine_zq_cossingen4[1] ? (-cs_sine_x2_cossingen) : cs_sine_x2_cossingen);
assign cs_sine_y = (cs_sine_zq_cossingen4[2] ? (-cs_sine_y2_cossingen) : cs_sine_y2_cossingen);
assign cs_cosine_za = (cs_cosine_z[19] ? (19'd524287 - cs_cosine_z[18:0]) : cs_cosine_z[18:0]);
assign cs_cosine_adr = cs_cosine_za[18:10];
assign cs_cosine_zd = ((cs_cosine_za[9:0] - 10'd512) + cs_cosine_z[19]);
assign cs_cosine_zd_cossingen0 = cs_cosine_zd;
assign cs_cosine_cossingen0 = (cs_cosine_lut_data_x | 16'd32768);
assign cs_cosine_x1_cossingen0 = ($signed({1'd0, cs_cosine_cossingen1}) - ((cs_cosine_lyd + $signed({1'd0, 6'd63})) >>> 3'd7));
assign cs_cosine_cossingen2 = cs_cosine_lut_data_y;
assign cs_cosine_y1_cossingen0 = ($signed({1'd0, cs_cosine_cossingen3}) + ((cs_cosine_lxd + $signed({1'd0, 6'd63})) >>> 3'd7));
assign cs_cosine_zq_cossingen0 = {cs_cosine_z[21], (cs_cosine_z[20] ^ cs_cosine_z[21]), (cs_cosine_z[19] ^ cs_cosine_z[20])};
assign cs_cosine_x2_cossingen = (cs_cosine_zq_cossingen4[0] ? cs_cosine_y1_cossingen1 : cs_cosine_x1_cossingen1);
assign cs_cosine_y2_cossingen = (cs_cosine_zq_cossingen4[0] ? cs_cosine_x1_cossingen1 : cs_cosine_y1_cossingen1);
assign cs_cosine_x = (cs_cosine_zq_cossingen4[1] ? (-cs_cosine_x2_cossingen) : cs_cosine_x2_cossingen);
assign cs_cosine_y = (cs_cosine_zq_cossingen4[2] ? (-cs_cosine_y2_cossingen) : cs_cosine_y2_cossingen);
assign slice_proxy0 = (accu_qb + accu_mcm0);
assign slice_proxy1 = (accu_qb + accu_mcm1);
assign slice_proxy2 = (accu_qb + accu_mcm2);
assign slice_proxy3 = (accu_qb + accu_mcm3);
assign slice_proxy4 = (accu_qb + accu_mcm4);
assign slice_proxy5 = (accu_qb + accu_mcm5);
assign slice_proxy6 = (accu_qb + accu_mcm6);
assign slice_proxy7 = (accu_qb + accu_mcm7);

always @(posedge sys_clk) begin
	cs_carrier_z <= accu_z0[19:3];
	modulation <= ($signed({1'd0, multiplier}) * cs_carrier_x);
	cs_sine_z <= modulation;
	cs_cosine_z <= (modulation + phase);
	output_i_scaled <= (cs_cosine_x * $signed({1'd0, i_amp}));
	output_q_scaled <= (cs_sine_x * $signed({1'd0, q_amp}));
	i <= output_i_scaled[32:17];
	q <= output_q_scaled[32:17];
	pdh_accumulator0 <= (phase_PDH + accu_z0);
	pdh_output[0] <= pdh_accumulator0[19];
	pdh_accumulator1 <= (phase_PDH + accu_z1);
	pdh_output[1] <= pdh_accumulator1[19];
	pdh_accumulator2 <= (phase_PDH + accu_z2);
	pdh_output[2] <= pdh_accumulator2[19];
	pdh_accumulator3 <= (phase_PDH + accu_z3);
	pdh_output[3] <= pdh_accumulator3[19];
	pdh_accumulator4 <= (phase_PDH + accu_z4);
	pdh_output[4] <= pdh_accumulator4[19];
	pdh_accumulator5 <= (phase_PDH + accu_z5);
	pdh_output[5] <= pdh_accumulator5[19];
	pdh_accumulator6 <= (phase_PDH + accu_z6);
	pdh_output[6] <= pdh_accumulator6[19];
	pdh_accumulator7 <= (phase_PDH + accu_z7);
	pdh_output[7] <= pdh_accumulator7[19];
	accu_clr_d <= clr;
	accu_qa <= (accu_qa + (f <<< 2'd3));
	accu_i <= f;
	if ((clr | accu_clr_d)) begin
		accu_qa <= 1'd0;
	end
	if (accu_clr_d) begin
		accu_i <= 1'd0;
	end
	accu_qb <= (accu_qa + (accu_p <<< 4'd12));
	accu_z0 <= slice_proxy0[32:12];
	accu_z1 <= slice_proxy1[32:12];
	accu_z2 <= slice_proxy2[32:12];
	accu_z3 <= slice_proxy3[32:12];
	accu_z4 <= slice_proxy4[32:12];
	accu_z5 <= slice_proxy5[32:12];
	accu_z6 <= slice_proxy6[32:12];
	accu_z7 <= slice_proxy7[32:12];
	{cs_carrier_lut_data_yd, cs_carrier_lut_data_xd, cs_carrier_lut_data_y, cs_carrier_lut_data_x} <= cs_carrier_dat_r;
	cs_carrier_zd_cossingen1 <= cs_carrier_zd_cossingen0;
	cs_carrier_zd_cossingen2 <= cs_carrier_zd_cossingen1;
	cs_carrier_lxd <= (cs_carrier_zd_cossingen2 * $signed({1'd0, (cs_carrier_lut_data_xd | 4'd8)}));
	cs_carrier_lyd <= (cs_carrier_zd_cossingen2 * $signed({1'd0, cs_carrier_lut_data_yd}));
	cs_carrier_cossingen1 <= cs_carrier_cossingen0;
	cs_carrier_x1_cossingen1 <= cs_carrier_x1_cossingen0;
	cs_carrier_cossingen3 <= cs_carrier_cossingen2;
	cs_carrier_y1_cossingen1 <= cs_carrier_y1_cossingen0;
	cs_carrier_zq_cossingen1 <= cs_carrier_zq_cossingen0;
	cs_carrier_zq_cossingen2 <= cs_carrier_zq_cossingen1;
	cs_carrier_zq_cossingen3 <= cs_carrier_zq_cossingen2;
	cs_carrier_zq_cossingen4 <= cs_carrier_zq_cossingen3;
	{cs_sine_lut_data_yd, cs_sine_lut_data_xd, cs_sine_lut_data_y, cs_sine_lut_data_x} <= cs_sine_dat_r;
	cs_sine_zd_cossingen1 <= cs_sine_zd_cossingen0;
	cs_sine_zd_cossingen2 <= cs_sine_zd_cossingen1;
	cs_sine_lxd <= (cs_sine_zd_cossingen2 * $signed({1'd0, (cs_sine_lut_data_xd | 4'd8)}));
	cs_sine_lyd <= (cs_sine_zd_cossingen2 * $signed({1'd0, cs_sine_lut_data_yd}));
	cs_sine_cossingen1 <= cs_sine_cossingen0;
	cs_sine_x1_cossingen1 <= cs_sine_x1_cossingen0;
	cs_sine_cossingen3 <= cs_sine_cossingen2;
	cs_sine_y1_cossingen1 <= cs_sine_y1_cossingen0;
	cs_sine_zq_cossingen1 <= cs_sine_zq_cossingen0;
	cs_sine_zq_cossingen2 <= cs_sine_zq_cossingen1;
	cs_sine_zq_cossingen3 <= cs_sine_zq_cossingen2;
	cs_sine_zq_cossingen4 <= cs_sine_zq_cossingen3;
	{cs_cosine_lut_data_yd, cs_cosine_lut_data_xd, cs_cosine_lut_data_y, cs_cosine_lut_data_x} <= cs_cosine_dat_r;
	cs_cosine_zd_cossingen1 <= cs_cosine_zd_cossingen0;
	cs_cosine_zd_cossingen2 <= cs_cosine_zd_cossingen1;
	cs_cosine_lxd <= (cs_cosine_zd_cossingen2 * $signed({1'd0, (cs_cosine_lut_data_xd | 4'd8)}));
	cs_cosine_lyd <= (cs_cosine_zd_cossingen2 * $signed({1'd0, cs_cosine_lut_data_yd}));
	cs_cosine_cossingen1 <= cs_cosine_cossingen0;
	cs_cosine_x1_cossingen1 <= cs_cosine_x1_cossingen0;
	cs_cosine_cossingen3 <= cs_cosine_cossingen2;
	cs_cosine_y1_cossingen1 <= cs_cosine_y1_cossingen0;
	cs_cosine_zq_cossingen1 <= cs_cosine_zq_cossingen0;
	cs_cosine_zq_cossingen2 <= cs_cosine_zq_cossingen1;
	cs_cosine_zq_cossingen3 <= cs_cosine_zq_cossingen2;
	cs_cosine_zq_cossingen4 <= cs_cosine_zq_cossingen3;
	if (sys_rst) begin
		cs_carrier_z <= 17'd0;
		modulation <= 22'd0;
		i <= 16'd0;
		q <= 16'd0;
		cs_sine_z <= 22'd0;
		cs_cosine_z <= 22'd0;
		output_i_scaled <= 33'd0;
		output_q_scaled <= 33'd0;
		pdh_accumulator0 <= 20'd0;
		pdh_accumulator1 <= 20'd0;
		pdh_accumulator2 <= 20'd0;
		pdh_accumulator3 <= 20'd0;
		pdh_accumulator4 <= 20'd0;
		pdh_accumulator5 <= 20'd0;
		pdh_accumulator6 <= 20'd0;
		pdh_accumulator7 <= 20'd0;
		pdh_output <= 8'd0;
	end
end

reg [31:0] lut[0:511];
reg [8:0] memadr;
always @(posedge sys_clk) begin
	memadr <= cs_carrier_adr;
end

assign cs_carrier_dat_r = lut[memadr];

initial begin
	$readmemh("./lut.init", lut);
end

reg [37:0] lut_1[0:511];
reg [8:0] memadr_1;
always @(posedge sys_clk) begin
	memadr_1 <= cs_sine_adr;
end

assign cs_sine_dat_r = lut_1[memadr_1];

initial begin
	$readmemh("./lut_1.init", lut_1);
end

reg [37:0] lut_2[0:511];
reg [8:0] memadr_2;
always @(posedge sys_clk) begin
	memadr_2 <= cs_cosine_adr;
end

assign cs_cosine_dat_r = lut_2[memadr_2];

initial begin
	$readmemh("./lut_2.init", lut_2);
end

endmodule
