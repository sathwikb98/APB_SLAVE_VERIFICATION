class apb_test extends uvm_test;
  `uvm_component_utils(apb_test)
  apb_slv_environment env;
  apb_slv_sequence seq;
  function new(string name = "apb_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_slv_environment::type_id::create("env",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq = apb_slv_sequence::type_id::create("seq");
    seq.start(env.active_agent.sequencer);
    phase.drop_objection(this);
  endtask
endclass

class apb_simple_write extends uvm_test;
  `uvm_component_utils(apb_simple_write)
  
  apb_slv_environment env;
  apb_slv_sequence_simple_write seq;
  
  function new(string name ="apb_simple_write", uvm_component parent =null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_slv_environment::type_id::create("env",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq = apb_slv_sequence_simple_write::type_id::create("seq");
    seq.start(env.active_agent.sequencer);
    phase.drop_objection(this);
  endtask
endclass

class apb_simple_read extends uvm_test;
  `uvm_component_utils(apb_simple_read)
  
  apb_slv_environment env;
  apb_slv_sequence_simple_read seq;
  
  function new(string name ="apb_simple_write", uvm_component parent =null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_slv_environment::type_id::create("env",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq = apb_slv_sequence_simple_read::type_id::create("seq");
    seq.start(env.active_agent.sequencer);
    phase.drop_objection(this);
  endtask
endclass

class apb_continous_write_read extends uvm_test;
  `uvm_component_utils(apb_continous_write_read)
  
  apb_slv_environment env;
  apb_slv_sequence_write_read_continous seq;
  
  function new(string name ="apb_continous_write_read", uvm_component parent =null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_slv_environment::type_id::create("env",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq = apb_slv_sequence_write_read_continous::type_id::create("seq");
    seq.start(env.active_agent.sequencer);
    phase.drop_objection(this);
  endtask
endclass

class apb_strb_enb_write extends uvm_test;
    `uvm_component_utils(apb_strb_enb_write)
  
  apb_slv_environment env;
  apb_slv_sequence_strb_enb_write seq;
  
  function new(string name ="apb_strb_enb_write", uvm_component parent =null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_slv_environment::type_id::create("env",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq = apb_slv_sequence_strb_enb_write::type_id::create("seq");
    seq.start(env.active_agent.sequencer);
    phase.drop_objection(this);
  endtask
  
endclass


class apb_pslverr_out_of_bound_paddr extends uvm_test;
  `uvm_component_utils(apb_pslverr_out_of_bound_paddr)
  
  apb_slv_environment env;
  apb_slv_sequence_pslverr seq;
  
  function new(string name ="apb_pslverr_out_of_bound_paddr", uvm_component parent =null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_slv_environment::type_id::create("env",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq = apb_slv_sequence_pslverr::type_id::create("seq");
    seq.start(env.active_agent.sequencer);
    phase.drop_objection(this);
  endtask  
endclass


class apb_write_flw_read extends uvm_test;
  `uvm_component_utils(apb_write_flw_read)
  
  apb_slv_environment env;
  apb_slv_sequence_write_followed_by_read seq;
  
  function new(string name ="apb_write_flw_read", uvm_component parent =null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_slv_environment::type_id::create("env",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq = apb_slv_sequence_write_followed_by_read::type_id::create("seq");
    seq.start(env.active_agent.sequencer);
    phase.drop_objection(this);
  endtask  
endclass


class apb_regression extends uvm_test;
  `uvm_component_utils(apb_regression)
  
  apb_slv_environment env;
  apb_slv_regression_tst seq;
  
  function new(string name ="apb_regression", uvm_component parent =null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_slv_environment::type_id::create("env",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq = apb_slv_regression_tst::type_id::create("seq");
    seq.start(env.active_agent.sequencer);
    phase.drop_objection(this);
  endtask 
endclass
