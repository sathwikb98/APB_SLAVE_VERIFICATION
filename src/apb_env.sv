class apb_slv_environment extends uvm_env;
  
  apb_slv_agent active_agent;
  apb_slv_agent passive_agent;  
  apb_slv_subscriber subscriber;
  apb_slv_scoreboard scoreboard;

  `uvm_component_utils(apb_slv_environment)

  function new(string name = "apb_slv_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      uvm_config_db#(uvm_active_passive_enum)::set(this,"active_agent","is_active",UVM_ACTIVE);
      uvm_config_db#(uvm_active_passive_enum)::set(this,"passive_agent","is_active",UVM_PASSIVE);
      
      active_agent = apb_slv_agent::type_id::create("active_agent", this);
      passive_agent = apb_slv_agent::type_id::create("passive_agent", this);
      subscriber = apb_slv_subscriber::type_id::create("subscriber", this);
      scoreboard = apb_slv_scoreboard::type_id::create("scoreboard", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
      active_agent.active_monitor.act_mon_port.connect(subscriber.act_mon_imp);
      active_agent.active_monitor.act_mon_port.connect(scoreboard.act_mon_imp);
      passive_agent.passive_monitor.pass_mon_port.connect(subscriber.analysis_export);
      passive_agent.passive_monitor.pass_mon_port.connect(scoreboard.pass_mon_imp);
  endfunction : connect_phase

endclass 
