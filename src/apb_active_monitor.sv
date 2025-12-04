class apb_slv_active_monitor extends uvm_monitor;

  apb_slv_seq_item seq_item;
  virtual apb_slv_intf vif;
  event active_monitor_trigger;
  uvm_analysis_port #(apb_slv_seq_item) act_mon_port;

  `uvm_component_utils(apb_slv_active_monitor)

  function new(string name = "apb_slv_active_monitor", uvm_component parent = null);
    super.new(name, parent);
    act_mon_port = new("act_mon_port", this);
  endfunction 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      if(!uvm_config_db #(virtual apb_slv_intf)::get(this, "", "vif", vif))
    `uvm_fatal(get_type_name(), $sformatf("Not set at top"));
      if(!uvm_config_db#(event)::get(this,"","active_monitor_trigger",active_monitor_trigger))
        `uvm_fatal(get_type_name(), $sformatf("active_monitor_trigger not set at top"));
  endfunction 

   task run_phase(uvm_phase phase);
    repeat(1)@(vif.act_monitor_cb);
    seq_item = apb_slv_seq_item::type_id::create("seq_item");
    forever begin
      @(active_monitor_trigger);
      seq_item.psel = vif.psel;
      seq_item.penable = vif.penable;
      seq_item.pwrite = vif.pwrite;
      seq_item.paddr = vif.paddr;
      seq_item.pwdata = vif.pwdata;
      seq_item.pstrb = vif.pstrb;
      $display("active_monitor ...sequence...");
      `uvm_info(get_full_name(),seq_item.conv_to_str(),UVM_LOW)
      act_mon_port.write(seq_item);
    end
  endtask 
endclass : apb_slv_active_monitor
