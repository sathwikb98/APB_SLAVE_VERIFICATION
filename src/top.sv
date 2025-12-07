`include "uvm_macros.svh"
`include "apb_pkg.sv"
`include "apb_interface.sv"
`include "apb_slave.sv"
`include "apb_assertion.sv"
`include "apb_bind.sv"

module top;
  bit pclk;
  logic presetn;
  always #5 pclk = ~pclk;
  event active_monitor_trigger, passive_monitor_trigger;
 
  import uvm_pkg::*;
  import apb_pkg::*;
  
  initial begin
    presetn = 1'b0;
    #45 presetn = 1'b1;
  end
  
  apb_slv_intf intf(pclk,presetn);
  
  apb_slave #(`ADDR_WIDTH, `DATA_WIDTH, `MEM_DEPTH)dut (.PRESETn(presetn),.PCLK(pclk),.PADDR(intf.paddr),.PSEL(intf.psel),.PENABLE(intf.penable),.PWRITE(intf.pwrite),.PWDATA(intf.pwdata),.PSTRB(intf.pstrb),.PREADY(intf.pready),.PSLVERR(intf.pslverr), .PRDATA(intf.prdata));
  
  initial begin
    uvm_config_db#(virtual apb_slv_intf)::set(uvm_root::get(),"*","vif",intf);

    
    uvm_config_db#(event)::set(uvm_root::get(),"*","active_monitor_trigger",active_monitor_trigger);
    uvm_config_db#(event)::set(uvm_root::get(),"*","passive_monitor_trigger",passive_monitor_trigger);
    
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  initial begin
    //run_test("apb_test");
    //run_test("apb_simple_write");
    //run_test("apb_simpletinous_write_read");
    //run_test("apb_strb_enb_write");
    //run_test("apb_pslverr_out_of_bound_paddr");
    //run_test("apb_write_flw_read");
    run_test("apb_regression");
    #100 $finish;
  end
endmodule
