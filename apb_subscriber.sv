`uvm_analysis_imp_decl(_act_mon)
class apb_slv_subscriber extends uvm_subscriber#(apb_slv_seq_item);

  uvm_analysis_imp_act_mon#(apb_slv_seq_item, apb_slv_subscriber) act_mon_imp;
  
  apb_slv_seq_item input_trans, output_trans;
  real input_coverage, output_coverage;

  `uvm_component_utils(apb_slv_subscriber)

  covergroup input_cov();
    psel: coverpoint input_trans.psel;
    penable: coverpoint input_trans.penable;
    pwrite: coverpoint input_trans.pwrite;
      
      paddr_byte_0: coverpoint input_trans.paddr[7:0] { bins hit = {[0:255]}; }
      paddr_byte_1: coverpoint input_trans.paddr[15:8]{ bins hit = {[0:255]}; }
      paddr_byte_2: coverpoint input_trans.paddr[23:16]{ bins hit = {[0:255]}; }
      paddr_byte_3: coverpoint input_trans.paddr[31:24]{ bins hit = {[0:255]}; }
      
      pwdata_byte_0: coverpoint input_trans.pwdata[7:0]  { bins  hit = {[0:255]}; }
      pwdata_byte_1: coverpoint input_trans.pwdata[15:8] { bins  hit = {[0:255]}; }
      pwdata_byte_2: coverpoint input_trans.pwdata[23:16]{ bins  hit = {[0:255]}; }
      pwdata_byte_3: coverpoint input_trans.pwdata[31:24]{ bins  hit = {[0:255]}; }
      
      // valid cross between paddr and pdata
    paddr_x_pwdata_0: cross paddr_byte_0, pwdata_byte_0;
      paddr_x_pwdata_1: cross paddr_byte_1, pwdata_byte_1;
      paddr_x_pwdata_2: cross paddr_byte_2, pwdata_byte_2;
      paddr_x_pwdata_3: cross paddr_byte_3, pwdata_byte_3;
      
      // cross penable and psel
      penable_x_psel : cross psel, penable{ // excluding the penable = 1, psel = 0 part
        ignore_bins bad = binsof(psel) intersect {0} && binsof(penable) intersect {1};
      } 
      
      // cross paddr and pwrite
      paddr_x_pwrite_0 : cross paddr_byte_0, pwrite;
      paddr_x_pwrite_1 : cross paddr_byte_1, pwrite;
      paddr_x_pwrite_2 : cross paddr_byte_2, pwrite;
      paddr_x_pwrite_3 : cross paddr_byte_3, pwrite;
      
  endgroup : input_cov
  
  covergroup output_cov();
      pready: coverpoint output_trans.pready;
      pslverr: coverpoint output_trans.pslverr;
      prdata_byte_0: coverpoint output_trans.prdata[7:0]  { bins hit = {[0:255]}; }
      prdata_byte_1: coverpoint output_trans.prdata[15:8] { bins hit = {[0:255]}; }
      prdata_byte_2: coverpoint output_trans.prdata[23:16]{ bins hit = {[0:255]}; }
      prdata_byte_3: coverpoint output_trans.prdata[31:24]{ bins hit = {[0:255]}; }
    endgroup : output_cov

  function new (string name = "apb_slv_subscriber", uvm_component parent = null);
    super.new(name, parent);
    input_cov = new();
    output_cov = new();
    input_trans = apb_slv_seq_item::type_id::create("input_trans");
    output_trans = apb_slv_seq_item::type_id::create("output_trans");
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    act_mon_imp = new("act_mon_imp", this);
  endfunction

  
  function void write(apb_slv_seq_item t);
    output_trans = t;
    output_cov.sample();
  endfunction 
  
  function void write_act_mon(apb_slv_seq_item t);
    input_trans = t;
    input_cov.sample();
  endfunction 


  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    input_coverage = input_cov.get_coverage();
    output_coverage = output_cov.get_coverage();
  endfunction : extract_phase

  function void report_phase(uvm_phase phase);
      super.report_phase(phase);
      `uvm_info(get_type_name(), $sformatf("[Input]: Coverage --> %0.2f", input_coverage), UVM_MEDIUM);
      `uvm_info(get_type_name(), $sformatf("[Output]: Coverage --> %0.2f", output_coverage), UVM_MEDIUM);
  endfunction : report_phase

endclass : apb_slv_subscriber
