module custom_scan_latch(test_se, si, reset, g, d, q);
   input test_se;
   input si;
   input g;
   input reset;
   input d;
   output q;

   reg    q;
   
   wire   d_in = test_se ? si : d;

   //synopsys async_set_reset "reset"
   always @(g or d_in or reset)
     begin
        if (reset == 1)
          begin
             q = 0;
          end
        else 
          begin
             if (g)
               begin
                  q = d_in;
               end
          end
     end // always @ (g or ri_scan or reset)
   
endmodule // custom_scan_latch

module mousetrap(reset, ri, ai, ro, ao, L, phi1, phi2, test_se, test_si, test_so);
   input ri, ao;
   output ai, ro;
   output L;
   input  phi1, phi2; // clocks //
   input  test_se; // test scan enable //   
   input  test_si;
   output test_so;

   input  reset;
   
   wire   latchen, latchen_latched;
   wire   g;

   // phi2 at this level is used for ATPG, at top-level it is a muxed clock between phi2 ext and mousetrap latchen_latched //
 
   // mousetrap control XNOR primitive //
   xnor mousetrapxnor (latchen, ro, ao);
   
   custom_scan_latch L1 (.test_se(test_se), .si(test_si), .reset(reset), .g(phi1), .d(latchen), .q(latchen_latched));

   custom_scan_latch L2 (.test_se(test_se), .si(latchen_latched), .reset(reset), .g(phi2), .d(ri), .q(ro));

   assign test_so = ro;
   
   assign L = latchen_latched;
   assign ai = ro;
                  
endmodule // mousetrap

module top(reset, ri, ai, ro, ao, phi1, phi2, test_se, test_si, test_so, test_mode);

   input ri, ao;
   output ai, ro;
   input  phi1, phi2; // clocks //
   input  test_se; // test scan enable //   
   input  test_si;
   output test_so;

   input  test_mode;
   input  reset;
   
   wire phi2_muxed; // multiplexed clock //
   wire L; // latchen_latched from phi1 clock //
   
   // phi2 clock mux //
   assign phi2_muxed = (test_mode ? phi2 : L);
   
   mousetrap MT (.reset(reset), .ri(ri), .ai(ai), .ro(ro), .ao(ao), .L(L), .phi1(phi1), .phi2(phi2_muxed), .test_se(test_se), .test_si(test_si), .test_so(test_so)); // muxed clock //
   
   
endmodule // top
