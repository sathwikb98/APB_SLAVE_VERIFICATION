class apb_slv_agent extends uvm_agent;
  
  apb_slv_sequencer sequencer;
  apb_slv_driver driver;
  apb_slv_active_monitor active_monitor;
  apb_slv_passive_monitor passive_monitor;
  
  `uvm_component_utils(apb_slv_agent)

  function new(string name = "apb_slv_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(),
        $sformatf("Agent %s is %s",
              get_full_name(),
              (get_is_active()==UVM_ACTIVE) ? "ACTIVE" : "PASSIVE"),
        UVM_MEDIUM)
    if(!uvm_config_db#(uvm_active_passive_enum)::get(this,"","is_active",is_active))
      `uvm_fatal(get_full_name()," AGENT TYPE NOT CORRECTLY SET !")

    if(get_is_active == UVM_ACTIVE) begin
      sequencer = apb_slv_sequencer::type_id::create("sequencer", this);
      driver = apb_slv_driver::type_id::create("driver", this);
      active_monitor = apb_slv_active_monitor::type_id::create("active_monitor",this);
    end
    else begin
          passive_monitor = apb_slv_passive_monitor::type_id::create("passive_monitor", this);
    end
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(get_is_active == UVM_ACTIVE)begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

endclass 
