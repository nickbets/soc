/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : W-2024.09-SP2
// Date      : Thu May 22 02:35:35 2025
/////////////////////////////////////////////////////////////


module custom_scan_latch_0 ( test_se, si, reset, g, d, q );
  input test_se, si, reset, g, d;
  output q;
  wire   n1, n2, n3, n4;

  sg13g2_dlhrq_1 q_reg ( .GATE(g), .D(n2), .RESET_B(n1), .Q(q) );
  sg13g2_inv_1 U2 ( .A(reset), .Y(n1) );
  sg13g2_a22oi_1 U5 ( .A1(d), .A2(n3), .B1(test_se), .B2(si), .Y(n4) );
  sg13g2_inv_1 U3 ( .A(n4), .Y(n2) );
  sg13g2_inv_1 U4 ( .A(test_se), .Y(n3) );
endmodule


module custom_scan_latch_1 ( test_se, si, reset, g, d, q );
  input test_se, si, reset, g, d;
  output q;
  wire   n5, n6, n7, n8;

  sg13g2_dlhrq_1 q_reg ( .GATE(g), .D(n7), .RESET_B(n8), .Q(q) );
  sg13g2_inv_1 U2 ( .A(reset), .Y(n8) );
  sg13g2_a22oi_1 U5 ( .A1(d), .A2(n6), .B1(test_se), .B2(si), .Y(n5) );
  sg13g2_inv_1 U3 ( .A(n5), .Y(n7) );
  sg13g2_inv_1 U4 ( .A(test_se), .Y(n6) );
endmodule


module mousetrap ( reset, ri, ai, ro, ao, L, phi1, phi2, test_se, test_si, 
        test_so );
  input reset, ri, ao, phi1, phi2, test_se, test_si;
  output ai, ro, L, test_so;
  wire   ro, n1;
  assign test_so = ro;
  assign ai = ro;

  custom_scan_latch_0 L1 ( .test_se(test_se), .si(test_si), .reset(reset), .g(
        phi1), .d(n1), .q(L) );
  custom_scan_latch_1 L2 ( .test_se(test_se), .si(L), .reset(reset), .g(phi2), 
        .d(ri), .q(ro) );
  sg13g2_xnor2_1 U1 ( .A(ro), .B(ao), .Y(n1) );
endmodule

