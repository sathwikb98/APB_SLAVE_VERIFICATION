interface apb_slv_intf(input bit pclk, presetn);
  logic [`DATA_WIDTH-1:0] prdata;
  logic pready;
  logic pslverr;
  
  logic psel;
  logic penable;
  logic pwrite;
  logic [`ADDR_WIDTH-1:0] paddr;
  logic [`DATA_WIDTH-1:0] pwdata;
  logic [(`DATA_WIDTH/8)-1:0] pstrb;
  
  clocking drv_cb@(posedge pclk);
    output psel, penable, pwrite, paddr, pwdata, pstrb;
    input pready;
  endclocking

  clocking act_monitor_cb@(posedge pclk);
    input psel, penable, pwrite, paddr, pwdata, pstrb;
  endclocking
  
//   clocking pas_montior_cb@(posedge pclk);
//     input prdata, pready, pslverr;
//   endclocking
  
  modport DRV (clocking drv_cb, input presetn);
  modport ACT_MON(clocking act_monitor_cb, input presetn);
  //modport PAS_MON(clocking pas_monitor_cb, input presetn);
   
endinterface
