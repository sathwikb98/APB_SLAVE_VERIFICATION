class apb_slv_seq_item extends uvm_sequence_item;
  rand bit psel;
  rand bit penable;
  rand bit pwrite;
  
  rand bit [`ADDR_WIDTH-1:0] paddr;
  rand bit [`DATA_WIDTH-1:0] pwdata;
  rand bit [((`DATA_WIDTH/8)-1) : 0] pstrb;
  
  bit [`DATA_WIDTH-1:0] prdata;
  bit pready;
  bit pslverr;
  
  `uvm_object_utils_begin(apb_slv_seq_item)
  `uvm_field_int(psel,UVM_ALL_ON)
  `uvm_field_int(penable,UVM_ALL_ON)
  `uvm_field_int(pwrite,UVM_ALL_ON)
  `uvm_field_int(paddr,UVM_ALL_ON | UVM_HEX)
  `uvm_field_int(pstrb,UVM_ALL_ON | UVM_BIN)
  `uvm_field_int(pwdata,UVM_ALL_ON | UVM_HEX)
  
  `uvm_field_int(pready,UVM_ALL_ON)
  `uvm_field_int(pslverr,UVM_ALL_ON)
  `uvm_field_int(prdata, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name ="apb_slv_seq_item");
    super.new(name);
  endfunction

  function string conv_to_str();
    return $sformatf("apb_seq_item -> psel: %0b | penable : %0b | pwrite : %0b | paddr : %0d | pwdata : %0d | pstrb : %4b | prdata : %0d | pready : %0b | pslverr : %0b",psel,penable,pwrite,paddr,pwdata,pstrb,prdata,pready,pslverr);
  endfunction

endclass
