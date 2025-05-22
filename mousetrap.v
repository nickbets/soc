module mousetrap(reset, ri, ai, ro, ao, L, phi1, phi2, test_se, test_si, test_so);
   input ri, ao;
   output ai, ro;
   output L;
   input  phi1, phi2; // clocks //
   input  test_se; // test scan enable //   
   input  test_si;
   output test_so;
   
   input  reset;
   
   wire   latchen;   
   wire   g;
   reg    latchout1, latchout;

   wire   ri_scan, latchout1_scan;
   
   assign g = (test_se ? phi1 : latchen);

   assign ri_scan = (test_se ? test_si : ri);
   
   //synopsys async_set_reset "reset"
   always @(g or ri_scan or reset)
     begin
        if (reset == 1)
          begin
             latchout1 = 0;
          end
        else 
          begin
             if (g)
               begin
                  latchout1 = ri_scan;
               end
          end
     end

   assign latchout1_scan = (test_se ? ri_scan : latchout1);
   
   //synopsys async_set_reset "reset"
   always @(phi2 or latchout1_scan or reset)
     begin
        if (reset == 1)
          begin
             latchout = 0;
          end
        else 
          begin
             if (phi2)
               begin
                  latchout = latchout1_scan;
               end
          end
     end

   assign test_so = latchout;
   
   assign ro = latchout;
   assign L = latchen;
   assign ai = ro;
                   
   // primitive //
   xnor mousetrapxnor (latchen, latchout, ao);
                   
endmodule // mousetrap
    