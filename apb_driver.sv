class apb_slv_driver extends uvm_driver #(apb_slv_seq_item);

  virtual apb_slv_intf vif;
  `uvm_component_utils(apb_slv_driver)
    event active_monitor_trigger, passive_monitor_trigger;
  
  function new(string name = "apb_slv_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      if(!uvm_config_db #(virtual apb_slv_intf)::get(this, "", "vif", vif))
        `uvm_fatal(get_type_name(), $sformatf("VIF not set at top"));
      if(!uvm_config_db#(event)::get(this,"","active_monitor_trigger",active_monitor_trigger))
        `uvm_fatal(get_type_name(), $sformatf("active_monitor_trigger not set !"));
      if(!uvm_config_db#(event)::get(this,"","passive_monitor_trigger",passive_monitor_trigger))
         `uvm_fatal(get_type_name(), $sformatf("passive_monitor_trigger not set !"));
         
  endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        @(posedge vif.drv_cb);
    forever
    begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask : run_phase

  virtual task drive();
    vif.psel <= req.psel;
    vif.penable <= req.penable;
    vif.pwrite <= req.pwrite;
    vif.paddr <= req.paddr;
    vif.pwdata <= req.pwdata;
    vif.pstrb <= req.pstrb;
    @(posedge vif.drv_cb);
    ->active_monitor_trigger;
    if(vif.penable && vif.psel) begin 
      @(posedge vif.drv_cb); 
      ->passive_monitor_trigger;
    end
  endtask : drive
  
endclass : apb_slv_driver
