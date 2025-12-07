bind apb_slv_intf apb_assertion assertion_inst(
  .pclk(pclk),
  .presetn(presetn),
  .prdata(prdata),
  .pready(pready),
  .pslverr(pslverr),
  
  .psel(psel),
  .penable(penable),
  .pwrite(pwrite),
  .paddr(paddr),
  .pwdata(pwdata),
  .pstrb(pstrb)
);
