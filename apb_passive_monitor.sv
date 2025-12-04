class apb_slv_passive_monitor extends uvm_monitor;

   apb_slv_seq_item seq_item;
   virtual apb_slv_intf vif;
   event passive_monitor_trigger;
   uvm_analysis_port #(apb_slv_seq_item) pass_mon_port;

   `uvm_component_utils(apb_slv_passive_monitor)

   function new(string name = "apb_slv_passive_monitor", uvm_component parent = null);
     super.new(name, parent);
     pass_mon_port = new("pass_mon_port", this);
   endfunction : new
  
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     if(!uvm_config_db #(virtual apb_slv_intf)::get(this, "", "vif", vif))
       `uvm_fatal(get_type_name(), $sformatf("Not set act_event at top"));
     if(!uvm_config_db#(event)::get(this,"","passive_monitor_trigger",passive_monitor_trigger))
       `uvm_fatal(get_type_name(), $sformatf("Not set pas_event at top"));
  endfunction : build_phase

   task run_phase(uvm_phase phase);
    seq_item = apb_slv_seq_item::type_id::create("apb_slv_seq_item");
    forever begin
      @(passive_monitor_trigger);
      seq_item.prdata = vif.prdata;
      seq_item.pready = vif.pready;
      seq_item.pslverr = vif.pslverr;
      $display("passive_monitor ...sequence...");
      `uvm_info(get_full_name,seq_item.conv_to_str,UVM_LOW)
      pass_mon_port.write(seq_item);
    end
  endtask : run_phase
endclass : apb_slv_passive_monitor
