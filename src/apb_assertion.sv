interface apb_assertion(pclk, presetn, psel, penable, pwrite, pstrb, pwdata, paddr, prdata, pready, pslverr);
  input pclk;
  input presetn;
  input [(`DATA_WIDTH/8)-1:0]pstrb;
  input psel;
  input penable;
  input pwrite;
  input [`DATA_WIDTH-1:0]pwdata;
  input [`ADDR_WIDTH-1:0]paddr;
  input [`DATA_WIDTH-1:0]prdata;
  input pready;
  input pslverr;

  //RESET CHECK
  property reset_check;
    @(posedge pclk) !presetn |=> (prdata == 0 && pslverr == 0);
  endproperty
  assert property(reset_check)
  //$info("PRESETn Assertion Passed");
  else
    $error("PRESETn Assertion Failed");

  //FUNCTIONALITY CHECK

  ///1
  property write_check;
    @(posedge pclk) disable iff(!presetn) (psel && penable && pwrite) |=>
    ($stable(pwdata) && $stable(paddr)) until (!penable && pready);
  endproperty

  assert property(write_check)
  //$info("write_check Assertion Passed");
  else
    $error("write_check Assertion Failed");
    

  ///2
  property read_check;
    @(posedge pclk) disable iff(!presetn) (psel && penable && !pwrite) |=>
    ($stable(paddr)) until (!penable && pready);
  endproperty

  assert property(read_check)
    //$info("read_check Assertion Passed");
  else
    $error("read_check Assertion Failed");
  
  
  //SLVERR CHECK
  property slave_err;
    @(posedge pclk) disable iff(!presetn) (penable && pready && (paddr >`MEM_DEPTH) ) |-> pslverr;
  endproperty

  //SLVERR VALIDITY
  assert property(slave_err)
    //$info("SLVERR Assertion Passed");
  else
    $error("SLVERR Assertion Failed");


  property slave_err_validity;
    @(posedge pclk) disable iff(!presetn) pslverr |-> (psel && penable && pready);
  endproperty

  assert property(slave_err_validity)
    //$info("SLVERR VALID Assertion Passed");
  else
    $error("SLVERR VALID Assertion Failed");

endinterface
