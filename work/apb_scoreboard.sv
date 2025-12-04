`uvm_analysis_imp_decl(_act_imp)
`uvm_analysis_imp_decl(_pas_imp)

class apb_slv_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_slv_scoreboard)
  
  uvm_analysis_imp_act_imp#(apb_slv_seq_item, apb_slv_scoreboard) act_mon_imp;
  uvm_analysis_imp_pas_imp#(apb_slv_seq_item, apb_slv_scoreboard) pass_mon_imp;
  
  apb_slv_seq_item act_q[$], pass_q[$], input_seq, actual_seq;
  
  bit [`DATA_WIDTH-1:0] mem [0:`MEM_DEPTH-1];
  
  int match, mismatch;
  
  function new(string name="apb_slv_scoreboard", uvm_component parent =null);
    super.new(name,parent);
    act_mon_imp = new("active_imp",this);
    pass_mon_imp = new("passive_imp",this);
  endfunction
  
  function void write_act_imp(apb_slv_seq_item req);
    act_q.push_back(req);
  endfunction
  
  function void write_pas_imp(apb_slv_seq_item req);
    pass_q.push_back(req);
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
      wait(act_q.size > 0 && pass_q.size > 0);
      input_seq = act_q.pop_front;
      actual_seq = pass_q.pop_front;
      apb_ref_compare_n_compute(input_seq, actual_seq);
    end
  endtask
  
  task apb_ref_compare_n_compute(apb_slv_seq_item input_seq, actual_seq);
    if(input_seq.pwrite && input_seq.penable) begin
      for(int i=0; i < `DATA_WIDTH/8; i++) begin
        if(input_seq.pstrb[i]) begin
          mem[input_seq.paddr][i*8 +: 8] = input_seq.pwdata[i*8 +: 8]; // write only the valid byte to the memory
        end
        input_seq.pslverr = (!(input_seq.paddr < `MEM_DEPTH))? 1'b1 : 1'b0;
      end
      `uvm_info(get_type_name, $sformatf("mem : %0p\nexp_pslverr : %0b",mem,input_seq.pslverr), UVM_LOW)
    end
    else if(!input_seq.pwrite && input_seq.penable) begin // read operation...
      input_seq.pslverr = (!(input_seq.paddr < `MEM_DEPTH))? 1'b1 : 1'b0; // expected pslverr !!
      
      if(!input_seq.pslverr) begin
        if(mem[input_seq.paddr] == actual_seq.prdata) begin
        match++;
        `uvm_info(get_full_name, "MATCH HAS OCCURED...", UVM_LOW)
        `uvm_info(get_full_name(), $sformatf("@addres -> mem : %0d  |  rdata : %0d",mem[input_seq.paddr],actual_seq.prdata), UVM_LOW)
      end
      else begin
        mismatch++;
        `uvm_info(get_full_name, "MISMATCH HAS OCCURED !!", UVM_LOW)
        `uvm_info(get_full_name(), $sformatf("@addres -> mem : %0d  |  rdata : %0d",mem[input_seq.paddr],actual_seq.prdata), UVM_LOW)
      end

      end
      else begin :input_pslverr_is_high
        if(actual_seq.pslverr) begin
          match++;
          `uvm_info(get_full_name, "MATCH HAS OCCURED WITH PSLVERR...", UVM_LOW)
          `uvm_info(get_full_name(), $sformatf("@slverr -> exp_slv_err : %0b | act_slv_err : %0b",input_seq.pslverr,actual_seq.pslverr), UVM_LOW)
        end
        else begin
          mismatch++;
          `uvm_info(get_full_name, "MISMATCH HAS OCCURED WITH PSLVERR !!", UVM_LOW)
          `uvm_info(get_full_name(), $sformatf("@slverr -> exp_slv_err : %0b | act_slv_err : %0b",input_seq.pslverr,actual_seq.pslverr), UVM_LOW)
        end
      end :input_pslverr_is_high
    end    
  endtask
  
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info(get_type_name(), $sformatf("match : %0d | mismatch : %0d",match,mismatch), UVM_LOW)
  endfunction
  
endclass
