module flopr(input logic clk,
				 input logic reset,
				 input logic [2:0] d,
				 output logic [2:0] q);

always_ff @(posedge clk, posedge reset)
	if (reset) q <= 4'b0;
	else q<= d;

endmodule

module sequential_controller(input logic clk,
 input logic reset,
 input logic left, right,
 output logic la, lb, lc, ra, rb, rc);
 
 // structural
 
 logic n1, n2, n3, n4, n5, n6;
 logic m1, m2, m3, m4, m5, m6, m7;
 logic [2:0] d;
 logic [2:0] S;
 typedef enum logic [2:0] {A = 3'b000, 
									B = 3'b001, C = 3'b010, D = 3'b011, 
									E = 3'b100, F = 3'b101, G = 3'b110} 
									statetype;
 statetype state, nextstate;
 
 
 
 // state register
	flopr dflop(clk, reset, d ,S);

  // next state logic	
	
  and x0(m1, ~S[1], ~S[0], right);
  and x1(m2, S[2], ~S[1]);
  or z0(d[2], m1, m2);
 
  and x2(m3, ~S[1], S[0]);
  and x3(m4, ~S[2], S[1], ~S[0]);
  or z1(d[1], m3, m4);
  
  and x4(m5, ~S[2], ~S[1], ~S[0], left);
  and x5(m6, ~S[2], S[1], ~S[0]);
  and x6(m7, S[2], ~S[1], ~S[0]);
  or z2(d[0], m5, m6, m7);
 
  // output logic
  
  and a0(n1, ~S[2], S[1]); // use indexed values of d flip flop
  and a1(n2, ~S[2], S[0]);
  or o0(la, n1, n2);
  // -----------------
  and a2(lb, ~S[2], S[1]);
  // -----------------
  and a3(lc, S[1], S[0]);
  // -----------------
  and a4(n3, S[2], ~S[0]);
  and a5(n4, S[2], ~S[1]);
  or o1(ra, n3, n4);
  // -----------------
  and a6(n5, S[2], ~S[1], S[0]);
  and a7(n6, S[2], S[1], ~S[0]);
  or o2(rb, n5, n6);
  // -----------------
  and a8(rc, S[2], S[1]);
  
endmodule
